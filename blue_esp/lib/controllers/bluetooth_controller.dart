import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController{

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  Future scanDevices() async{
    flutterBlue.startScan(timeout: const Duration(seconds: 10));

    flutterBlue.stopScan();
  }

  Stream<List<ScanResult>> get scanResult => flutterBlue.scanResults;

  
}