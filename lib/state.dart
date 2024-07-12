import 'package:flutter/material.dart';
import 'package:pieno/io/http.dart';
import 'package:pieno/models.dart';
import 'package:provider/provider.dart';

class UserState extends ChangeNotifier {
  String? token;
  String? username;
  Car? _activeCar;
  List<Car>? _cars;

  set activeCar(Car? car) {
    _activeCar = car;
    notifyListeners();
  }

  Car? get activeCar => _activeCar;

  UserState([
    this.token,
    this.username,
    this._activeCar,
  ]);

  Future<List<Car>> getCars(BuildContext context) async {
    _cars ??= await Provider.of<Api>(context, listen: false).getCars();
    return _cars!;
  }
}
