// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return OrderModel(
    id: json['id'] as int?,
    amount: json['amount'] as int?,
    packs: (json['packs'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(int.parse(k), e as int),
    ),
  )..mPacks = (json['mPacks'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(int.parse(k), e as int),
    );
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'mPacks': instance.mPacks?.map((k, e) => MapEntry(k.toString(), e)),
      'packs': instance.packs?.map((k, e) => MapEntry(k.toString(), e)),
    };
