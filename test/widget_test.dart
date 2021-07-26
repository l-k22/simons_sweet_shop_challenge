// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Store Calculator', () {
    // use SplayTree self-balancing binary tree O(log(n))
    SplayTreeMap<int, int> packMap = SplayTreeMap();

    setUp(() {
      packMap = SplayTreeMap();
    });
    // tearDown(() {
    //   packMap = SplayTreeMap();
    // });

    void cartCleanUp(SplayTreeMap<int, int> sMap) {
      // // there are scenarios were the store uses multiple packs when the order could be fulfiled with a larger pack this only happens with the smallest pack size.
      // var firstKey = sMap.firstKey(); // find smallest pack size
      // var secondKey =
      //     sMap.firstKeyAfter(sMap.firstKey()); // find second smallest pack size

      // if (firstKey != null && secondKey != null) {
      //   if (secondKey % firstKey == 0) {
      //     if (sMap[firstKey] == 2) {
      //       // update value of second element with that of the first
      //       sMap.update(secondKey, (value) => value + 1);
      //       // remove the original value
      //       sMap.update(firstKey, (value) => value - value);
      //     }
      //   }
      // }
      //TODO replacement cleanup method to handle prime numbers

      sMap.forEach((fKey, fValue) {
        sMap.forEach((sKey, sValue) {
          // compare each <k,v> pair to one another.
          // ~ operater truncates any remainder rounds it down towards zero. Should a whole since we've already checked
              int divPack = (sKey ~/ fKey);
          if (fKey != sKey) {
            // use modulo operator to find smaller packs that multiples can tally up into larger packs.
            if (sMap[fKey]! > 1 && divPack == 2) {
              // check if pack contains more than one order.
              // update packs with new amounts
              sMap.update(sKey, (value) => value + 1);
              // remove order from small pack
              sMap.update(fKey, (value) => value - 2);

              print(
                  ' ZZZ sky % fkey == 1 : $sKey % $fKey = ${(sKey ~/ fKey)}'); // truncate down
              //   // update value of second element with that of the first
              // sMap.update(sKey, (value) => );
              // // remove the original value
              // sMap.update(fKey, (value) => );
              cartCleanUp(sMap); // recursive call
            }
          }
        });
      });

      // recursive call
    }

    cartCalc(List<int> nPackArray, int originalOrder, int nAmountSum) {
      // Simon's shopping cart calculator
      print(
          '===== calling cartCalc order amount: ${nAmountSum.toString()} =====');
      int nLargestPackSize = 0;
      int remainingAmount = 0;
      var differencePackSizeLessOrEqualTo;
      var differencePackSizeGreaterOrEqualTo;

      if (nPackArray.isNotEmpty && nAmountSum > -1) {
        // check the sweet pack list is not empty and order not a negative number
        var nearestPackSizeLessOrEqualTo = nPackArray
            .where((pack) => (pack <= nAmountSum))
            .toList()
              ..sort(); // split the array find the pack size less or equal to the order amount

        var nearestPackSizeGreaterOrEqualTo = nPackArray
            .where((pack) => (pack >= nAmountSum))
            .toList()
              ..sort(); // split the array find the pack size greater or equal to the order

        int nearestPackLE = nearestPackSizeLessOrEqualTo
            .lastWhere((element) => true, orElse: () => -1);
        // get last element of the array of smaller packs otherwise return null
        int nearestPackGE = nearestPackSizeGreaterOrEqualTo
            .firstWhere((element) => true, orElse: () => -1);
        // get first element of the  array of larger packs otherwise return null
        print('xx <= nearestPackLE $nearestPackLE');
        print('xx >= nearestPackGE $nearestPackGE');

        if (nearestPackLE > 0) {
          differencePackSizeLessOrEqualTo = nAmountSum -
              nearestPackLE; // find the difference in sweets between largest of the smallest and order amount
        } else {
          differencePackSizeLessOrEqualTo = null;
        }
        if (nearestPackGE > 0) {
          differencePackSizeGreaterOrEqualTo = nearestPackGE -
              nAmountSum; // find the difference in sweets between smallest of the largest and order amount
        } else {
          differencePackSizeGreaterOrEqualTo = null;
        }
        print(' <= difference ${differencePackSizeLessOrEqualTo.toString()}');
        print(
            ' >= difference ${differencePackSizeGreaterOrEqualTo.toString()}');

// if the largest of the smaller packs is not null whilst smallest of the largest is null
        if (differencePackSizeLessOrEqualTo != null) {
          if (differencePackSizeGreaterOrEqualTo == null) {
            print(
                '\\ ${differencePackSizeLessOrEqualTo.toString()} < ${differencePackSizeGreaterOrEqualTo.toString()}');
            nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
          } else if (differencePackSizeLessOrEqualTo <
              differencePackSizeGreaterOrEqualTo) {
            print(
                '\\ else if ${differencePackSizeLessOrEqualTo.toString()} < ${differencePackSizeGreaterOrEqualTo.toString()}');
            nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
          }
        }
// if the smallest of the larger packs is not null whilst largest of the smaller is null
        if (differencePackSizeGreaterOrEqualTo != null) {
          if (differencePackSizeLessOrEqualTo == null) {
            nLargestPackSize = nearestPackSizeGreaterOrEqualTo.first;
            print(
                '/ if ${differencePackSizeLessOrEqualTo.toString()} > ${differencePackSizeGreaterOrEqualTo.toString()}');
          } else if (differencePackSizeGreaterOrEqualTo <=
              differencePackSizeLessOrEqualTo) {
            // if difference is less or equal to that of the smaller pack size then we should opt for the larger pack size!
            print(
                '/ else if ${differencePackSizeLessOrEqualTo.toString()} > ${differencePackSizeGreaterOrEqualTo.toString()}');
            nLargestPackSize = nearestPackSizeLessOrEqualTo.last;
          }
        }
// last scenario - if the order amount is equal to the nearest pack size we pick the larger pack to reduce wastage
        if ((nearestPackLE == nAmountSum) || (nearestPackGE == nAmountSum)) {
          nLargestPackSize = nAmountSum;
        }

        if (nLargestPackSize > 0) {
          // check for pack size 0 we should never have a 0 key
          packMap.update(nLargestPackSize, (value) => value = value + 1);
          print('>>> set ${packMap.toString()}');
        }
        remainingAmount = nAmountSum -
            nLargestPackSize; // amount of sweets yet to be fulfilled
        print('>>> remainingAmount ${remainingAmount.toString()}');

        if (remainingAmount > 0) {
          // if there is even 1 sweet leftover we need to add another pack
          cartCalc(
              nPackArray, originalOrder, remainingAmount); // recursive call
        } else {
          // there are scenarios were the store uses multiple packs when the order could be fulfiled with a larger pack this only happens with the smallest pack size.
          cartCleanUp(packMap);
          print('>>> set ${packMap.toString()}');
          packMap.removeWhere((key, value) => value == 0);
          print(
              '= *** = Order for ${originalOrder.toString()} sweets has been fulfilled ${packMap.toString()} = *** =');
        }
      } else {
        print("Sweet Pack Array Empty! Simon's Sweet Shop Is Out of Stock!");
      }
    }

    test('should fulfil order for 642 sweet', () {
      List<int> packArray = [
        2000,
        500,
        1000,
        250,
        5000
      ]; // un-ordered default list of packs

      packArray.forEach((element) =>
          packMap[element] = 0); // create map from array with default value 0
      int amountSum = 642; // order amount

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum); // call our shopping cart calculator with the sorted array of packs with the customer's order amount
    });

    test('should fulfil order for 1 sweet', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 1;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 250 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 250;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 251 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 251;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 501 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 501;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 12001 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 12001;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 750 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 750;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 749 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 749;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 100 sweets', () {
      List<int> packArray = [5, 2, 4, 1, 3];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 100;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order of prime numbered packs for 87 sweets', () {
      List<int> packArray = [5, 2, 7, 41, 3, 101, 59];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 87;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order of prime numbered packs for 199 sweets', () {
      List<int> packArray = [5, 2, 7, 41, 3, 59];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 199;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });

    test('should fulfil order for 751 sweets', () {
      List<int> packArray = [2000, 500, 1000, 250, 5000];

      packArray.forEach((element) => packMap[element] = 0);
      int amountSum = 751;

      cartCalc(packArray..sort((curr, next) => curr.compareTo(next)), amountSum,
          amountSum);
    });
  }); // end of current test group
}
