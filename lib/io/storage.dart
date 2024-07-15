import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> writeCarTokenToFile(String carToken) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/car_token.txt');
  await file.writeAsString(carToken);
}

Future<String?> readCarTokenFromFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/car_token.txt');
    if (await file.exists()) {
      String carToken = await file.readAsString();
      return carToken;
    }
  } catch (e) {
    print('Error reading car token from file: $e');
  }
  return null;
}

Future<void> writeIndexToFile(String index) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/index.txt');
  await file.writeAsString(index);
}

Future<int?> readIndexFromFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/index.txt');
    if (await file.exists()) {
      String index = await file.readAsString();
      return int.parse(index);
    }
  } catch (e) {
    print('Error reading index from file: $e');
  }
  return null;
}
