/* 
  Sweet Model
  'id' is the unique identifier 
  'name' is the name of the sweet
  'description' is the admin's description of the sweet.

  We could have 'stock' amount for each sweet type to ensure that the customer
  does not order more sweet than Simon can supply.
  'SKU' code would also make database look up simplier
 */

class Sweet {
  final int? id;
  final String name, description;

  Sweet({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description};
  }

  @override
  String toString() {
    return 'Sweet {id: $id, name: $name $description }';
  }
}
