// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SweetModel _$SweetModelFromJson(Map<String, dynamic> json) {
  return SweetModel(
    id: json['id'] as int?,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$SweetModelToJson(SweetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
