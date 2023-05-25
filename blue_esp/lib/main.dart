import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


import 'package:convert/convert.dart';

void main() {
  runApp(const EspBlue());
}

class EspBlue extends StatefulWidget {
  const EspBlue({super.key});

  @override
  State<EspBlue> createState() => _EspBlueState();
}

class _EspBlueState extends State<EspBlue> {
  BluetoothDevice? conectedDevice;
  BluetoothCharacteristic? currentBlueCharacteristic;
  String serviceUuid = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  String characterMandarUuid = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  String characterReceberUuid = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EspBlue'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Informacao1'),
              const Text('botao1'),
              const Text('Informacao1'),
              const Text('botao1'),
              IconButton(
                onPressed: () async {
                  final List<ScanResult> scanResult = await FlutterBluePlus
                      .instance
                      .startScan(timeout: const Duration(seconds: 3));
                  for (int i = 0; i < scanResult.length; i++) {
                    print(scanResult[i].device.name);
                    if (scanResult[i].device.name == "ChurrasTech") {
                      await scanResult[i].device.connect();
                      conectedDevice = scanResult[i].device;
                      final List<BluetoothService>? services =
                          await conectedDevice?.discoverServices();
                      for (var x = 0; x < services!.length; x++) {
                        print(services[x].uuid);
                        if (services[x].uuid.toString().toLowerCase() ==
                            serviceUuid.toLowerCase()) {
                          final lsOfChar = services[x].characteristics;
                          for (var y = 0; y < lsOfChar.length; y++) {
                            if (lsOfChar[y].uuid.toString().toLowerCase() ==
                                characterReceberUuid.toLowerCase()) {
                              currentBlueCharacteristic = lsOfChar[y];
                              print("Foiiiii");
                            }
                          }
                        }
                      }
                    }
                  }
                },
                icon: const Icon(Icons.search_outlined),
              ),
              IconButton(
                  onPressed: () async {
                    await conectedDevice?.disconnect();
                  },
                  icon: const Icon(Icons.exit_to_app)),
              IconButton(
                  onPressed: () async {
                    if (currentBlueCharacteristic == null) {
                      print(
                          "EEEEEEEEEEERRRRRRRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRRRRRR");
                    } else {
                        currentBlueCharacteristic?.value.listen((value) {
                            print("AAAAAAAAAAAAAAAAA");
                            print(utf8.decode(value));
                        });
                        currentBlueCharacteristic?.setNotifyValue(true);
                      /*try {
                        final List<int> rawEsp = await currentBlueCharacteristic!.read();
                        print(rawEsp);} 
                      on Exception catch (error) {print(error);}*/

                      //currentBlueCharacteristic!.write(utf8.encode('Ping')); //Só para mandar
                      
                    }
                  },
                  icon: const Icon(Icons.send)),
            ],
          ),
        ),
      ),
    );
  }
}
