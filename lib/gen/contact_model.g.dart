// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactModelImpl _$$ContactModelImplFromJson(Map<String, dynamic> json) =>
    _$ContactModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      group: json['group_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$ContactModelImplToJson(_$ContactModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'group_name': instance.group,
      'phone': instance.phone,
      'email': instance.email,
      'image': instance.image,
    };
