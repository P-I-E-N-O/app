import 'package:pieno/models.dart';
import 'package:dio/dio.dart';

import 'dart:convert' show json;

class Api {
  Api({required this.client});
  final Dio client;
  late String message = "";
  late String _token;

  Future<String> logIn(String email, String password) async {
    final response = await client.post('/users/auth/login', data: {
      "email": email,
      "password": password,
    });
    return response.data["token"];
  }

  void setToken(String token) {
    _token = token;
    client.options.headers.addAll({"Authorization": "Bearer $token"});
  }

  String get token => _token;

  Future<User?> getLoggedInUser() async {
    try {
      final response = await client.get('/users/auth');
      var user = User(
        name: response.data["user"]["name"],
        surname: response.data["user"]["surname"],
        email: response.data["user"]["email"],
      );
      return user;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<void> sendFcmToken(String? fcmToken) async {
    await client.put("/users/auth/fcm", data: {"token": fcmToken});
  }

  Future<Pump> getBestPump(double latitudine, double longitudine, int tanksize,
      int fuelLevel, double consPerKm) async {
    final response = await client
        .get("/driving-api/api_obtain_data/get_data", queryParameters: {
      'latitudine': latitudine,
      'longitudine': longitudine,
      'serbatoio': tanksize.toString(),
      'consumo': fuelLevel.toString(),
      'consumo_per_km': consPerKm.toString()
    });

    return Pump.fromJson(response.data);
  }

  Future<List<Car>> getCars() async {
    final response = await client.get("/cars/");
    final carsData = response.data["cars"];

    List<Car> cars =
        (carsData as List<dynamic>).map<Car>((e) => Car.fromJson(e)).toList();
    return cars;
  }

  Future<List<Prediction>> getPredictions() async {
    final response = await client.get("/predictions-api/api/get_predizioni");
    final predictions = response.data["predizioni"];
    return (predictions as List<dynamic>)
        .map<Prediction>((e) => Prediction.fromJson(e))
        .toList();
  }

  Future<List<Price>> getPrices() async {
    final response = await client.get("/predictions-api/api/get_prezzi");
    final price = response.data["prezzi"];
    return (price as List<dynamic>)
        .map<Price>((e) => Price.fromJson(e))
        .toList();
  }

  Future<PutCarResponse> addCar(Car car) async {
    final Map<String, String> size = {
      "small": "small",
      "medium": "medium",
      "large": "large"
    };

    final response = await client.put("/cars/", data: {
      "name": car.name,
      "size": size[car.size],
      "plate_no": car.plateNo,
      "tank_size": car.tankSize,
      "fuel_type": car.fuelType.name.toLowerCase(),
    });

    return PutCarResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future addUser(User user) async {
    final response = await client.post("/users/auth/register", data: {
      "email": user.email,
      "name": user.name,
      "surname": user.surname,
      "password": user.password,
    });

    return response;
  }

  void checkStatusCode(int? statusCode) {
    switch (statusCode) {
      case 404:
        message = "Errore";
        return;
      case 400:
        message = "Password è troppo corta";
        return;
      case 409:
        message = "Utente esistente";
        return;
      case 200:
        message = "ok";
        return;
    }
  }

  Future updateUser(User user) async {
    final response = await client.put("/users/auth/register", data: {
      "email": user.email,
      "name": user.name,
      "surname": user.surname,
      "password": user.password,
    });

    return response;
  }

  Future<Map<String, double>> getColumnDataHttp(FuelType fuelType) async {
    Map<FuelType, String> fuel = {
      FuelType.petrol: "Benzina",
      FuelType.diesel: "Gasolio",
      FuelType.lpg: "GPL",
      FuelType.cng: "Metano",
    };
    final response = await client.get("/fuel_prediction/${fuel[fuelType]}");
    print("Response of getFuelPrediction: ${response.data}");
    Map<String, dynamic> res = json.decode(response.data);

    return res.cast<String, double>();
  }
}
