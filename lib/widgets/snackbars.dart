import 'package:flutter/material.dart';

SnackBar allFieldsRequired = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "All fields are required",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar passwordsDoNotMatch = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "Passwords do not match",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar invalidEmailOrPassword = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "Invalid email or password fields",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar userAlreadyExist = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "User already exists",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar carAlreadyExists = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "Car already exists",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar networkError = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "Network error",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);

SnackBar noActiveCars = const SnackBar(
  backgroundColor: Colors.black,
  content: Text(
    "Add a Car!",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);
