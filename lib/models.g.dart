// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      name: json['name'] as String,
      plateNo: json['plate_no'] as String,
      size: json['size'] as String,
      fuelLevel: (json['fuel_level'] as num).toInt(),
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuel_type']),
      tankSize: (json['tank_size'] as num).toInt(),
      ownerId: json['owner_id'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'id': instance.id,
      'fuel_level': instance.fuelLevel,
      'fuel_type': _$FuelTypeEnumMap[instance.fuelType]!,
      'image_url': instance.imageUrl,
      'name': instance.name,
      'owner_id': instance.ownerId,
      'plate_no': instance.plateNo,
      'size': instance.size,
      'tank_size': instance.tankSize,
    };

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.lpg: 'lpg',
  FuelType.cng: 'cng',
  FuelType.electric: 'electric',
  FuelType.balls: 'balls',
};
