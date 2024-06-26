import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

enum FuelType { petrol, diesel, lpg, cng, electric, balls }

extension FuelTypeString on FuelType {
  String get string => switch (this) {
        FuelType.balls => "Palline",
        FuelType.petrol => "Benzina",
        FuelType.diesel => "Nafta",
        FuelType.cng => "Metano",
        FuelType.lpg => "GPL",
        FuelType.electric => "Elettrico",
      };
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Car {
  String id = "";
  int fuelLevel;
  FuelType fuelType;
  String? imageUrl;
  final String name;
  String ownerId = "";
  final String plateNo;
  final String size;
  final int tankSize;

  // Map<String, double> cons_per_km = {
  //   "small": 0.05,
  //   "medium": 0.10,
  //   "large": 0.15
  // };

  // Car(
  //     {required this.name,
  //     required this.plateNo,
  //     required this.size,
  //     required this.tankSize,
  //     this.ownerId = "",
  //     this.id = "",
  //     this.imageUrl = ""});

  Car({
    required this.name,
    required this.plateNo,
    required this.size,
    required this.fuelLevel,
    required this.fuelType,
    required this.tankSize,
    required this.ownerId,
    required this.id,
  });

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
  Map<String, dynamic> toJson() => _$CarToJson(this);
}
