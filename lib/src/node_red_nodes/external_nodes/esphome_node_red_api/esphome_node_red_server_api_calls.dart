import 'dart:convert';

import 'package:http/http.dart';
import 'package:nodered/src/utils.dart';

class EspHomeNodeRedServerApiCalls {
  static Future<Set<EspHomeDeviceObject>> getAllEspHomeDevices() async {
    final Response discoveredDevices = await post(
      Uri.parse('http://localhost:1880/esphome/discovery'),
      encoding: Encoding.getByName('utf-8'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {},
    );

    final Set<Map<String, dynamic>> allDevices =
        (jsonDecode(discoveredDevices.body) as Set)
            .map((e) => e as Map<String, dynamic>)
            .toSet();

    final Set<EspHomeDeviceObject> listOfDevices = {};

    for (final Map<dynamic, dynamic> device in allDevices) {
      final EspHomeDeviceObject espHomeDeviceObject = EspHomeDeviceObject(
        port: device['port'] as int,
        board: device['board'] as String,
        platform: device['platform'] as String,
        mac: device['mac'] as String,
        version: device['version'] as String,
        host: device['host'] as String,
        address: device['address'] as String,
        family: device['family'] as String,
      );
      listOfDevices.add(espHomeDeviceObject);
    }

    logger.i(listOfDevices);
    return listOfDevices;
  }

  static Future<Set<EspHomeDeviceEntityObject>> getEspHomeDeviceEntities(
    String espHomeDeviceId,
  ) async {
    final Response entitiesOfDevice = await post(
      Uri.parse('http://localhost:1880/esphome/entities'),
      encoding: Encoding.getByName('utf-8'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        'deviceNode': espHomeDeviceId,
      },
    );

    final Set<Map<String, dynamic>> espHomeDeviceEntities =
        (jsonDecode(entitiesOfDevice.body) as Set)
            .map((e) => e as Map<String, dynamic>)
            .toSet();

    final Set<EspHomeDeviceEntityObject> entityList = {};

    for (final Map<String, dynamic> entity in espHomeDeviceEntities) {
      final EspHomeDeviceEntityObject espHomeDeviceEntityObject =
          EspHomeDeviceEntityObject.fromMap(entity);
      entityList.add(espHomeDeviceEntityObject);
    }
    return entityList;
  }
}

class EspHomeDeviceObject {
  EspHomeDeviceObject({
    required this.port,
    required this.board,
    required this.platform,
    required this.mac,
    required this.version,
    required this.host,
    required this.address,
    required this.family,
  });

  int port;
  String board;
  String platform;
  String mac;
  String version;
  String host;
  String address;
  String family;
}

class EspHomeDeviceEntityObject {
  EspHomeDeviceEntityObject({
    required this.key,
    required this.type,
    required this.name,
    required this.config,
  });

  factory EspHomeDeviceEntityObject.fromMap(Map<String, dynamic> entityMap) {
    return EspHomeDeviceEntityObject(
      key: entityMap['key'] as int,
      type: entityMap['type'] as String,
      name: entityMap['name'] as String,
      config: entityMap['config'] as Map,
    );
  }
  int key;
  String type;
  String name;
  Map config;
}
