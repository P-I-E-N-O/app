import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions() async {
  if (await Permission.bluetoothScan.request().isGranted &&
      await Permission.bluetoothConnect.request().isGranted &&
      await Permission.location.request().isGranted) {
    return true;
  } else {
    return false;
  }
}
