import 'package:flutter/foundation.dart';
import 'package:pieno/models.dart';

class UserState extends ChangeNotifier {
  String? token;
  String? username;
  Car? _activeCar;

  set activeCar(Car? car) {
    _activeCar = car;
    notifyListeners();
  }

  Car? get activeCar => _activeCar;

  UserState(
    this.token,
    this.username,
    this._activeCar,
  );
}
