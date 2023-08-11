import 'dart:async';
import 'dart:convert';

import 'package:air_flutter/view/connectedDeviceScreen.dart';
import 'package:air_flutter/view/nearDeviceScreen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class Bluetooth_Controller extends GetxController{

  final RxList<ScanResult> scanResultList = <ScanResult>[].obs;
  final Rx data = Rx<dynamic>(0);
  final RxString readableData = "".obs;
  BluetoothDevice? connectedDevice;
  final RxBool visibility = false.obs;
  bool isNotifying = false;
  BluetoothCharacteristic? desiredCharacteristic;
  late StreamSubscription<List<int>> notificationSubscription;


  void setVisibility (){
    visibility.value = !visibility.value;
  }

  Future<void> scanDevices() async {
    FlutterBluePlus.scanResults.listen((results) {
      // Add the new results to the scanResultList
      scanResultList.assignAll(results);
    });
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    await FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;
      // Connection successful, you can now read data from the device
      print('Connected to device: ${device.localName}');
      // await readDataFromDevice();

      Get.to(ConnectedDeviceScreen(deviceName: device.localName));
    } catch (e) {
      // Failed to connect to the device
      print('Failed to connect to device: ${device.localName}');
    }
  }

  String getData(){
    return readableData.value;
  }

  Future<void> setNotification() async{
    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.characteristicUuid.toString() == "fc6e1404-0c4e-4043-9d95-d257cd9ad5ff"){
          desiredCharacteristic = characteristic;
          break;
        }
      }
      if (desiredCharacteristic != null) {
        break;
      }
    }

    // Enable notifications for the desired characteristic
    if (desiredCharacteristic != null) {
      await desiredCharacteristic!.setNotifyValue(true);

      // Handle the notifications
      notificationSubscription = desiredCharacteristic!.value.listen((value) {
        // Process the data received in 'value'
        if (value.length == 4) {
          // Assuming the received value represents an unsigned 32-bit integer (4 bytes)
          int intValue = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
          data.value = intValue;
          print('Notification received as integer: ${data.value}');
        } else {
          readableData.value = utf8.decode(value);
          data.value = readableData.value;
          print('Notification received as string: ${data.value}');
        }
        data.value = value;
        print('Notification received: $data');
      }
      );

      isNotifying = true;
    }
  }

  void stopNotification() {
    if (isNotifying && desiredCharacteristic != null) {
      desiredCharacteristic?.setNotifyValue(false);
      // Cancel the subscription to stop receiving notifications
      notificationSubscription.cancel();
      isNotifying = false;
      print("Notification is off");
    }
  }

  Future<void> disconnectDevice() async{
    try{
      await connectedDevice?.disconnect();
      print("device is disconnected");
      Get.off(NearbyDevicesScreen());
    }
    catch (e){
      print("failed to disconnected $e");
    }

  }
}