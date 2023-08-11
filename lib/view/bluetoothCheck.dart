import 'package:air_flutter/view/nearDeviceScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckBluetoothScreen extends StatefulWidget {
  @override
  _CheckBluetoothScreenState createState() => _CheckBluetoothScreenState();
}

class _CheckBluetoothScreenState extends State<CheckBluetoothScreen> {
  @override
  void initState() {
    super.initState();
    checkBluetoothAndLocationPermissions();
    print("in initstate");
  }

  Future<void> checkBluetoothAndLocationPermissions() async {
    print("checking permissions");
    bool isBluetoothEnabled = await isBluetoothOn();
    bool isLocationGranted = await requestLocationPermission();

    print('Bluetooth is on: $isBluetoothEnabled');
    print('Location permission granted: $isLocationGranted');

    if (!isBluetoothEnabled || !isLocationGranted) {
      if (!isBluetoothEnabled) {
        await requestTurnOnBluetooth(); // Request user to turn on Bluetooth
      }

      if (!isLocationGranted) {
        await requestLocationPermission(); // Request user for location permission
      }

      // Check again after user enables Bluetooth and grants location permission
      checkBluetoothAndLocationPermissions();
    } else {
      // Both Bluetooth and location permissions are enabled, navigate to the UI screen
     Get.off(NearbyDevicesScreen());
    }
  }

  Future<bool> isBluetoothOn() async {
    return await FlutterBlue.instance.state.first == BluetoothState.on;
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<void> requestTurnOnBluetooth() async {
    // Show a dialog to ask the user to turn on Bluetooth
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Turn on Bluetooth"),
          content: const Text("Please turn on Bluetooth to use this app."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checking Bluetooth and Location'),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Show a loading indicator while checking Bluetooth and location status
      ),
    );
  }
}
