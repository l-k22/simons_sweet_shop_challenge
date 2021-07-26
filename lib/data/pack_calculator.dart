/* 
  PackCalculator class WORK IN PROGRESS
  Our algorithm for calculating sweets to pack size.
  The algorithm is developing from accessing the issue brought up in the challenge
  view PDF for details.
  Algorithm starts by finding the nearest pack size stored in an array for the 
  order amount, if the order amount equals a pack size then we are done. If not
  then we look for the nearest then look at the leftovers, we can look for the
  nearest amount.
  [orderAmount]
  [originalAmount]
  [remaining]

  comments would be removed for production
 */

import 'dart:collection';
import 'database_helper.dart';
import 'order_model.dart';

class PackCalculator {
  PackCalculator(
      {required int orderAmount,
      required List<int> packs,
      required SplayTreeMap<int, int> packMap}) {
    cartCalc(
        amount: orderAmount,
        originalAmount: orderAmount,
        packArray: packs,
        packMap: packMap);
  }

  Future<List<int>> getPackSizes() async {
    var db = DatabaseHelper();
    var packs = await db.fetchAllPacks();

    List<int> packArray = [];

    packs.forEach((element) {
      packArray.add(element.size);
    });

    return packArray;
  }

  void cartCalc(
      {required int amount,
      required int originalAmount,
      required List<int> packArray,
      required SplayTreeMap<int, int> packMap}) async {
    int nLargestPackSize = 0;
    int remainingAmount = 0;
    var packSizeDifferenceLessOrEqualTo;
    var packSizeDifferenceGreaterOrEqualTo;

    // check the sweet pack list is not empty and order not a negative number
    if (packArray.isNotEmpty && amount > -1) {
      // split the array find the pack size less or equal to the order amount
      var nearestPackSizeLessOrEqualTo =
          packArray.where((pack) => (pack <= amount)).toList()..sort();

      // split the array find the pack size greater or equal to the order
      var nearestPackSizeGreaterOrEqualTo =
          packArray.where((pack) => (pack >= amount)).toList()..sort();

      // get last element of the array of smaller packs otherwise return -1
      // Dart null check means we have to return a value
      var nearestPackLE = nearestPackSizeLessOrEqualTo
          .lastWhere((element) => true, orElse: () => -1);
      var nearestPackGE = nearestPackSizeGreaterOrEqualTo
          .firstWhere((element) => true, orElse: () => -1);

      // find the difference in sweets between largest of the smallest and order amount
      if (nearestPackLE > -1) {
        packSizeDifferenceLessOrEqualTo = amount - nearestPackLE;
      } else {
        packSizeDifferenceLessOrEqualTo = null;
      }

      // find the difference in sweets between smallest of the largest and order amount
      if (nearestPackGE > -1) {
        packSizeDifferenceGreaterOrEqualTo = nearestPackGE - amount;
      } else {
        packSizeDifferenceGreaterOrEqualTo = null;
      }

      // if the largest of the smaller packs is not null whilst smallest of the largest is null
      if (packSizeDifferenceLessOrEqualTo != null) {
        if (packSizeDifferenceGreaterOrEqualTo == null) {
          nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
        } else if (packSizeDifferenceLessOrEqualTo <
            packSizeDifferenceGreaterOrEqualTo) {
          nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
        }
      }

      // if the smallest of the larger packs is not null whilst largest of the smaller is null
      if (packSizeDifferenceGreaterOrEqualTo != null) {
        if (packSizeDifferenceLessOrEqualTo == null) {
          nLargestPackSize = nearestPackSizeGreaterOrEqualTo.first;
        } else if (packSizeDifferenceGreaterOrEqualTo <=
            packSizeDifferenceLessOrEqualTo) {
          // if difference is less or equal to that of the smaller pack size then we should opt for the larger pack size!
          nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
        }
      }

      // last scenario - if the order amount is equal to the nearest pack size we pick the larger pack to reduce wastage
      if ((nearestPackLE == amount) || (nearestPackGE == amount)) {
        nLargestPackSize = amount;
      }

      if (nLargestPackSize > 0) {
        // check for pack size 0 we should never have a 0 key
        print('>> $packMap nLargestPackSize $nLargestPackSize');
        packMap.update(nLargestPackSize, (value) => value = value + 1);
        print('>>> set $packMap');
      }
      remainingAmount =
          amount - nLargestPackSize; // amount of sweets yet to be fulfilled
      print('>>> remainingAmount $remainingAmount');

      if (remainingAmount > 0) {
        // if there is even 1 sweet leftover we need to add another pack

        cartCalc(
            amount: remainingAmount,
            originalAmount: originalAmount,
            packArray: packArray,
            packMap: packMap); // recursive call
      } else {
        // there are scenarios were the store uses multiple packs when the order could be fulfiled with a larger pack this only happens with the smallest pack size.
        await cartCleanUp(packMap);

        print('>>> set $packMap');

        packMap.removeWhere((key, value) => value == 0); // remove empty packs
        print(
            '=* * *= Order for $originalAmount sweets has been fulfilled $packMap =* * *=');

        try {
          var db = DatabaseHelper();
          OrderModel cartOrder =
              OrderModel(amount: originalAmount, packs: packMap);
          print('saving $cartOrder: ${cartOrder.packs}');

          await db.addOrderToCart(cartOrder);
        } catch (e) {
          print('Error attempting to save order \n$e');
        }
      }
    } else {
      print("Sweet Pack Array Empty! Simon's Sweet Shop Is Out of Stock!");
    }
  }

  Future<void> cartCleanUp(SplayTreeMap<int, int> sMap) async {
    /*  WORK IN PROGRESS! */
    /* there are scenarios were the store uses multiple packs when the order 
       could be fulfiled with a larger pack this only happens with the smallest
       pack size. */
    /* Need more research into Subset Sum algorithms */

    // fKey, sKey are our pack sizes, fVal sVal
    sMap.forEach((fKey, fVal) {
      sMap.forEach((sKey, sval) async {
        // tilda symbol truncates remainder down to nearest whole number towards zero
        int divPacks = sKey ~/ fKey; 
        if (fKey != sKey) {
          // if the value of first key is greater than 1 and key is divisible
          // by next key by 2 then update map until first key has 1 or 0 left
          if (fVal > 1 && divPacks == 2) {
            print('divPackKeys $sKey ~/ $fKey  = $divPacks');
            sMap.update(sKey, (value) => value + 1);
            sMap.update(fKey, (value) => value - 2);
            await cartCleanUp(sMap); // recursive call
          }
        }
      });
    });
  }
}
