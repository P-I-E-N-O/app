import 'package:flutter/material.dart';
import 'package:pieno/io/http.dart';
import 'package:pieno/io/storage.dart';
import 'package:pieno/models.dart';
import 'package:provider/provider.dart';

class UserState extends ChangeNotifier {
  String? _token;
  String? _username;
  Car? _activeCar;
  List<Car>? _cars;

  set activeCar(Car? car) {
    _activeCar = car;
    if (_activeCar != null && _activeCar!.token != null) {
      writeCarTokenToFile(_activeCar!.token!);
    }
    notifyListeners();
  }

  Car? get activeCar => _activeCar;

  UserState([
    this._token,
    this._username,
    this._activeCar,
  ]);

  set token(String? userToken) {
    _token = token;
    notifyListeners();
  }

  String? get token => _token;

  set username(String? newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  String? get username => _username;

  List<Car>? get cars => _cars;

  Future<List<Car>?> getCars(BuildContext context) async {
    _cars ??= await Provider.of<Api>(context, listen: false).getCars();
    notifyListeners();
    return _cars!;
  }
}
