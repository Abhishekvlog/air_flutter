import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../conrtollers/blutooth_controller.dart';

class NearbyDevicesScreen extends StatefulWidget {
  @override
  State<NearbyDevicesScreen> createState() => _NearbyDevicesScreenState();
}

class _NearbyDevicesScreenState extends State<NearbyDevicesScreen> {
  final Bluetooth_Controller controller = Get.put(Bluetooth_Controller());

  @override
  void initState() {
    super.initState();
    controller.scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices'),
      ),
      body: Obx(
            () {
          if (controller.scanResultList.isEmpty) {
            return const Center(
              child: Text('No devices found.'),
            );
          }
          return ListView.builder(
            itemCount: controller.scanResultList.length,
            itemBuilder: (context, index) {
              ScanResult result = controller.scanResultList[index];
              String deviceName = result.device.localName.isNotEmpty
                  ? result.device.localName
                  : 'Unknown Device';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  elevation: 0.5,
                  child: ListTile(
                    title: Text(deviceName),
                    subtitle: Text(result.device.id.toString()),
                    trailing: Text(result.rssi.toString()),
                    onTap: (){
                      controller.connectToDevice(result.device);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
