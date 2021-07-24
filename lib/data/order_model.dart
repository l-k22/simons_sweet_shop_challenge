import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

/* 
  Order model
  'id' is a unique identifier it also acts as our pack size
  'amount' is the order amount of packs calculated to complete the order.

  For this challenge could go without a model for the pack size since 
  it is simply an integer, however for future proofing if we wanted packs to be 
  more defined e.g if shop sells packs other than sweets, or add unique 
  sweet types e.g chocolate eclairs, gummies etc.
 */

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  int? id, amount; // customer order amount
  Map<int, int>? packs; // pack size to pack amount key value pair
  int? totalPacks; // total packs for cart display

  OrderModel({this.id, required this.amount, required this.packs});

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Map<String, dynamic> toMap() {
    return {'amount': amount, 'packs': packs};
  }

  OrderModel.fromMap(Map map) {
    totalPacks = 0;
    id = map["id"] as int;
    amount = map["amount"] as int;
    // SQFlite query map colons are replaced with equal symbols so
    // we need to remove and replace them as well as remove quotation
    // marks to use our model.
    String replaceString =
        map["packs"].replaceAll('=', ":").replaceAll('\"', "");

    final deQuotedString =
        replaceString.replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
      return '"${match.group(0)}"';
    });

    // decode json then parse key values as ints
    var decoded = json.decode(deQuotedString);
    
    final Map<dynamic, dynamic> convertedStringToMap =
        decoded.map((key, value) {
      totalPacks = totalPacks! + int.parse(key);
      return MapEntry(int.parse(key), int.parse(value));
    });

    packs = convertedStringToMap.cast();
  }

  @override
  String toString() {
    return 'Order {id: $id, order: $amount}';
  }
}
