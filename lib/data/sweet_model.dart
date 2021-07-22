import 'package:json_annotation/json_annotation.dart';

/* 
  Sweet Model
  'id' is the unique identifier 
  'name' is the name of the sweet
  'description' is the admin's description of the sweet.

  We could have 'stock' amount for each sweet type to ensure that the customer
  does not order more sweet than Simon can supply.
  'SKU' code would also make database look up simplier
 */
part 'sweet_model.g.dart';

@JsonSerializable()
class SweetModel {
  final int? id;
  final String name, description;

  SweetModel({this.id, required this.name, required this.description});

  factory SweetModel.fromJson(Map<String, dynamic> json) =>
      _$SweetModelFromJson(json);
  Map<String, dynamic> toJson() => _$SweetModelToJson(this);

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description};
  }

  @override
  String toString() {
    return 'Sweet {id: $id, name: $name $description }';
  }
}
