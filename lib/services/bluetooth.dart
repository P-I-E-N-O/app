import 'dart:async';
import 'dart:convert';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:http/http.dart' as http;
import 'package:pieno/io/storage.dart';

class BluetoothService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late QualifiedCharacteristic _rxCharacteristic;

  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  // ignore: unused_field
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  void startScanAndConnect() async {
    _scanSubscription = _ble.scanForDevices(withServices: []).listen((device) {
      if (device.name == "CAM") {
        _scanSubscription?.cancel();
        _connectToDevice(device.id);
      }
    }, onError: (dynamic error) {
      print("Scan error: $error");
    });
  }

  void _connectToDevice(String deviceId) {
    print("Attempting to connect to device: $deviceId");
    _connectionSubscription = _ble
        .connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 5),
    )
        .listen((connectionState) {
      print("Connection state: ${connectionState.connectionState}");
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        _discoverServices(deviceId);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        startScanAndConnect();
      }
    }, onError: (dynamic error) {
      print("Connection error: $error");
      startScanAndConnect();
    });
  }

  void _discoverServices(String deviceId) async {
    print("Discovering services for device: $deviceId");
    try {
      await _ble.discoverAllServices(deviceId);
      final services = await _ble.getDiscoveredServices(deviceId);
      for (var service in services) {
        print("Service found: ${service.id}");
        for (var characteristic in service.characteristics) {
          print("Characteristic found: ${characteristic.id}");
          if (characteristic.id ==
              Uuid.parse("b56854e2-60ab-4658-9eb5-0b2c0aad90af")) {
            print("Matching characteristic found");
            _rxCharacteristic = QualifiedCharacteristic(
              serviceId: service.id,
              characteristicId: characteristic.id,
              deviceId: deviceId,
            );
            _ble.subscribeToCharacteristic(_rxCharacteristic).listen((data) {
              _onDataReceived(data);
            }, onError: (dynamic error) {
              print("Subscription error: $error");
            });
          }
        }
      }
    } catch (e) {
      print("Service discovery error: $e");
    }
  }

  void _onDataReceived(List<int> data) {
    print("Data received: $data");
    String receivedData = String.fromCharCodes(data);
    _sendToDatabase(receivedData);
  }

  void _sendToDatabase(String data) async {
    String? carToken = await readCarTokenFromFile();
    if (carToken == null) {
      return;
    }

    final response = await http.post(
      Uri.parse('https://backend.pieno.dev/meter/'),
      headers: <String, String>{
        'Authorization': 'Bearer $carToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': data,
      }),
    );
    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }
}
