import 'package:flutter/foundation.dart';
import 'package:pieno/models.dart';

class UserState extends ChangeNotifier {
  String? token;
  String? username;
  Car? activeCar;

  UserState({
    this.token,
    this.username,
    this.activeCar,
  });
}
