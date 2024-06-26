import 'package:pieno/models.dart';

Future<List<Car>> getUserCars() async {
  return [
    Car(
      name: "R4",
      plateNo: "AA000AA",
      tankSize: 100,
      size: "piccola",
      ownerId: "Boss",
      id: "R4",
      fuelLevel: 78,
      fuelType: FuelType.balls,
    ),
    Car(
      name: "R5",
      plateNo: "AA000AA",
      tankSize: 120,
      size: "media",
      ownerId: "Boss",
      id: "R5",
      fuelLevel: 78,
      fuelType: FuelType.balls,
    ),
    Car(
      name: "R9",
      plateNo: "AA000AA",
      tankSize: 150,
      size: "grande",
      ownerId: "Boss",
      id: "R9",
      fuelLevel: 78,
      fuelType: FuelType.petrol,
    ),
  ];
}
