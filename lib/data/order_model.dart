/* 
  Order model
  'id' is a unique identifier it also acts as our pack size
  'amount' is the order amount of packs calculated to complete the order.

  For this challenge could go without a model for the pack size since 
  it is simply an integer, however for future proofing if we wanted packs to be 
  more defined e.g if shop sells packs other than sweets, or add unique 
  sweet types e.g chocolate eclairs, gummies etc.
 */

class OrderModel {
  int? id, amount;
  String? packs;

  OrderModel({this.id, required this.amount, required this.packs});

  Map<String, dynamic> toMap() {
    return {'amount': amount, 'packs': packs?.toString()};
  }

  OrderModel.fromMap(Map map) {
    id = map["id"] as int;
    amount = map["amount"] as int;

    packs = map["packs"] as String; // blocker need to convert non json string into a map
  }

  @override
  String toString() {
    return 'Order {id: $id, order: $amount}';
  }
}
