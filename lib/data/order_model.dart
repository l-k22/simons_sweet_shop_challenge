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
  int? id, amount;
  Map<int, int>? mPacks;
  String? packs;

  OrderModel({this.id, required this.amount, required this.packs});

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Map<String, dynamic> toMap() {
    print({'toMap $amount $packs'});
    return {'amount': amount, 'packs': packs};
  }

  OrderModel.fromMap(Map map) {
    id = map["id"] as int;
    amount = map["amount"] as int;
    print('fromMap ${map["packs"]}');
    // tempory code for prototyping
    String replaceString = map["packs"].toString().replaceAll('=', ":");
    print('newMap $replaceString');
    packs = replaceString ;
  }

  @override
  String toString() {
    return 'Order {id: $id, order: $amount}';
  }
}
