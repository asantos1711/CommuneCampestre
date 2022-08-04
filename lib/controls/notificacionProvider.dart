/*import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PushNotificationProvider {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications(int id) async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print('Running on ' + deviceData['model']);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        print('Running on ' + deviceData['name']);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) async {
     /* //Mandar al backen token
      print("===FCM Token");
      print(token);
      PatientToken patientToken = new PatientToken();
      patientToken.token = token;
      patientToken.fechaCreacion = DateTime.now();
      if (Platform.isAndroid) {
        patientToken.isApple = false;
        patientToken.deviceName = deviceData['model'];
      } else {
        patientToken.isApple = true;
        patientToken.deviceName = deviceData['name'];
      }
      if (id != null) {
        Patient patient = new Patient();
        patient.id = id;
        patientToken.patient = patient;
        String apiHost = AppConfig.instance.apiHost;
        var response = await http.post(apiHost + "/api/patient/addPatientToken",
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(patientToken.toJson()));
        if (response.statusCode == 200) {
          print("Se guardo correctamente Token ");
        }
      }*/

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print(
              '************************ ON  MESSAGE***********************************************');
          print("Mensaje " + message.toString());
          String title = message['notification']['title'];
          String msg = message['notification']['body'];
          print('on title $title');
          print('on msg $msg');
          var argumento = 'no-data';
          if (Platform.isAndroid) {
            argumento = message['data']['Comunicado'] ?? 'no-data';
          }
          print('Argumento en init ' + argumento);
          _mensajesStreamController.sink.add(msg);
        },
        onResume: (Map<String, dynamic> message) async {
          print(
              '************************ ON RESUME ***********************************************');
          print('on resume $message');
          var argumento = 'no-data';
          if (Platform.isAndroid) {
            argumento = message['data']['Comunicado'] ?? 'no-data';
          }
          print('Argumento en resume ' + argumento);
          _mensajesStreamController.sink.add(argumento);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print(
              '************************ ON LAUNCH ***********************************************');
          print('on launch $message');
          var argumento = 'no-data';
          if (Platform.isAndroid) {
            argumento = message['data']['Comunicado'] ?? 'no-data';
          }
          print('Argumento en resume ' + argumento);
          _mensajesStreamController.sink.add(argumento);
        },
      );
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}*/