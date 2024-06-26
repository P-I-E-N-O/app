import 'package:pieno/models.dart';

Future<List<Car>> getUserCars() async {
  return [
    Car(
      name: "R4",
      plateNo: "AA000AA",
      tankSize: 100,
      size: "piccola",
      ownerId: "Marco",
      id: "R4",
      fuelLevel: 78,
      fuelType: FuelType.balls,
    ),
    Car(
      name: "R5",
      plateNo: "AA000AA",
      tankSize: 120,
      size: "media",
      ownerId: "Carmine",
      id: "R5",
      fuelLevel: 90,
      fuelType: FuelType.balls,
    ),
    Car(
      name: "R9",
      plateNo: "AA000AA",
      tankSize: 150,
      size: "grande",
      ownerId: "Antonio",
      id: "R9",
      fuelLevel: 10,
      fuelType: FuelType.petrol,
    ),
  ];
}
