import 'package:air_flutter/view/nearDeviceScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../conrtollers/blutooth_controller.dart';

class ConnectedDeviceScreen extends StatefulWidget {
  final String deviceName;

  ConnectedDeviceScreen({super.key, required this.deviceName});

  @override
  State<ConnectedDeviceScreen> createState() => _ConnectedDeviceScreenState();
}

class _ConnectedDeviceScreenState extends State<ConnectedDeviceScreen> {
  final Bluetooth_Controller controller = Get.put(Bluetooth_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              // Handle the back button press
              Navigator.pop(context);
            },
        ),
        title: Text(
          widget.deviceName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
              onTap: () {
                controller.disconnectDevice();
                Get.off(NearbyDevicesScreen());
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.logout, color: Colors.white,),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        controller.setNotification();
                      },
                      child: const Text("Start session")),
                  OutlinedButton(
                      onPressed: () {
                        controller.stopNotification();
                        controller.setVisibility();
                      },
                      child: const Text("End session"))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(height: 4),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              final bool visibility = controller.visibility.value;
              final String data = controller.getData();
              final List<String> splitData = data.split(", ");
              if(splitData.length > 2){
                return Visibility(
                  visible: visibility,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Change this color to the desired border color
                          width: 1, // Change this value to adjust the border width
                        ),
                        borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('data is - ${controller.getData()}'),
                              const Text("Id", style: TextStyle(color: Colors.black54, fontSize: 18),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(splitData[0] , style: const TextStyle(color: Colors.black, fontSize: 20)),
                              ),
                              const Text("Time in Second", style: TextStyle(color: Colors.black54, fontSize: 18)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(splitData[1] , style: const TextStyle(color:  Colors.black, fontSize: 20)),
                              ),
                              const Text("Outcome", style: TextStyle(color: Colors.black54, fontSize: 18)),
                              Text(splitData[2], style: const TextStyle(color:  Colors.black, fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              else{
                return const Center(
                  child: Text("Ready for start session"),
                );
              }
            }),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Obx(() => Text("data is - ${controller.getData()}")),
            // ),
          ],
        ),
      ),
    );
  }
}
