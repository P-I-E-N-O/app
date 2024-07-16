// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      name: json['name'] as String,
      plateNo: json['plate_no'] as String,
      size: json['size'] as String,
      fuelLevel: (json['fuel_level'] as num?)?.toInt(),
      token: json['token'] as String?,
      fuelType: $enumDecodeNullable(_$FuelTypeEnumMap, json['fuel_type']) ??
          FuelType.gasoline,
      tankSize: (json['tank_size'] as num).toInt(),
      ownerId: json['owner_id'] as String,
      id: json['id'] as String,
    )..imageUrl = json['image_url'] as String?;

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
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
  FuelType.gasoline: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.lpg: 'lpg',
  FuelType.cng: 'cng',
  FuelType.electric: 'electric',
  FuelType.balls: 'balls',
};

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'password': instance.password,
    };

Pump _$PumpFromJson(Map<String, dynamic> json) => Pump(
      indirizzo: json['indirizzo'] as String,
      latitudine: (json['latitudine'] as num).toDouble(),
      longitudine: (json['longitudine'] as num).toDouble(),
      fuelPrices: Pump.fuelFromJson(json['fuel_prices']),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$PumpToJson(Pump instance) => <String, dynamic>{
      'id': instance.id,
      'indirizzo': instance.indirizzo,
      'latitudine': instance.latitudine,
      'longitudine': instance.longitudine,
      'fuel_prices':
          instance.fuelPrices.map((k, e) => MapEntry(_$FuelTypeEnumMap[k]!, e)),
    };

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
      data: json['data'] as String,
      pred: (json['pred'] as num).toInt(),
    );

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pred': instance.pred,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      data: json['data'] as String,
      prezzo: (json['prezzo'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'data': instance.data,
      'prezzo': instance.prezzo,
    };

PutCarResponse _$PutCarResponseFromJson(Map<String, dynamic> json) =>
    PutCarResponse(
      carId: json['car_id'] as String,
      carToken: json['car_token'] as String,
    );

Map<String, dynamic> _$PutCarResponseToJson(PutCarResponse instance) =>
    <String, dynamic>{
      'car_id': instance.carId,
      'car_token': instance.carToken,
    };
