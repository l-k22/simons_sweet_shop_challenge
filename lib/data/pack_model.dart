import 'package:json_annotation/json_annotation.dart';
/* 
  Sweet Pack model
  'size' is a unique identifier it also acts as our pack size

  For this challenge could go without a model for the pack size since 
  it is simply an integer, however for future proofing if we wanted packs to be 
  more defined e.g if shop sells packs other than sweets, or add unique 
  sweet types e.g chocolate eclairs, gummies etc.
 */
part 'pack_model.g.dart';

@JsonSerializable()
class PackModel {
  final int size;

  PackModel({required this.size});

  factory PackModel.fromJson(Map<String, dynamic> json) =>
      _$PackModelFromJson(json);
  Map<String, dynamic> toJson() => _$PackModelToJson(this);
  Map<String, dynamic> toMap() {
    return {'size': size};
  }

  // from the database value map we need the key value pair stored inside
  PackModel.fromMap(Map map) : size = map["size"] as int;

  @override
  String toString() {
    return 'Pack {size: $size}';
  }
}
