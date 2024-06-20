enum FuelType { petrol, diesel, lpg, cng, electric, balls }

class Car {
  String name;
  int fuelLevel;
  FuelType fuelType;

  Car({
    required this.name,
    required this.fuelLevel,
    required this.fuelType,
  });
}
