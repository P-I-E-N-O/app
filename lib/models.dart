import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
part 'models.g.dart';

enum FuelType { petrol, diesel, lpg, cng, electric, balls }

extension FuelTypeString on FuelType {
  String get string => switch (this) {
        FuelType.balls => "Little Balls",
        FuelType.petrol => "Gasoline",
        FuelType.diesel => "Diesel",
        FuelType.cng => "CNG",
        FuelType.lpg => "LPG",
        FuelType.electric => "Electric",
      };

  String get backendName => switch (this) {
        FuelType.balls => "Little Balls",
        FuelType.petrol => "Gasoline",
        FuelType.diesel => "Diesel",
        FuelType.cng => "CNG",
        FuelType.lpg => "LPG",
        FuelType.electric => "Electric",
      };
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Car {
  String id = "";
  String? token;
  int? fuelLevel;
  @JsonKey(defaultValue: FuelType.petrol)
  FuelType fuelType;
  String? imageUrl;
  final String name;
  String ownerId = "";
  final String plateNo;
  final String size;
  final int tankSize;

  Car({
    required this.name,
    required this.plateNo,
    required this.size,
    this.fuelLevel,
    this.token,
    required this.fuelType,
    required this.tankSize,
    required this.ownerId,
    required this.id,
  });

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
  Map<String, dynamic> toJson() => _$CarToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String name;
  final String surname;
  final String email;
  final String? password;

  User({
    required this.name,
    required this.surname,
    required this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Pump {
  int id;
  String indirizzo;
  double latitudine;
  double longitudine;
  @JsonKey(fromJson: fuelFromJson)
  Map<FuelType, double?> fuelPrices = {};

  static Map<FuelType, double?> fuelFromJson(json) {
    return {
      FuelType.balls: json["little_balls"],
    };
  }

  Pump({
    required this.indirizzo,
    required this.latitudine,
    required this.longitudine,
    required this.fuelPrices,
    required this.id,
  });

  factory Pump.fromJson(Map<String, dynamic> json) => _$PumpFromJson(json);
  Map<String, dynamic> toJson() => _$PumpToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Prediction {
  final String data;
  final int pred;

  Prediction({
    required this.data,
    required this.pred,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);
  Map<String, dynamic> toJson() => _$PredictionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Price {
  final dateFormat = DateFormat('E, d MMM yyyy HH:mm:ss');
  final String data;
  final double prezzo;

  Price({required this.data, required this.prezzo});

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  Map<String, dynamic> toJson() => _$PriceToJson(this);

  String convertToDDMM() {
    DateFormat ggMm = DateFormat("dd/MM");
    return ggMm.format(dateFormat.parse(data));
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PutCarResponse {
  PutCarResponse({required this.carId, required this.carToken});

  String carId;
  String carToken;

  factory PutCarResponse.fromJson(Map<String, dynamic> json) =>
      _$PutCarResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PutCarResponseToJson(this);
}
