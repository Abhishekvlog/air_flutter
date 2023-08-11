import 'package:air_flutter/conrtollers/blutooth_controller.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBluetoothDevices extends Mock implements BluetoothDevice {}

class MockBluetoothServices extends Mock implements BluetoothService {}

class MockBluetoothCharacteristic extends Mock
    implements BluetoothCharacteristic {}

void main() {
  setUp(() {
    late Bluetooth_Controller bluetoothController;
    late MockBluetoothDevices mockDevice;
    late MockBluetoothServices mockServices;
    late MockBluetoothCharacteristic mockCharacteristic;
  });

  test(
    "check near devices",
    () {
    },
  );
}
