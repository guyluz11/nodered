import 'dart:convert';

import 'package:http/http.dart';
import 'package:nodered/nodered.dart';

/// Class to define all Node RED repo functions
class NodeRedService {
  factory NodeRedService() {
    return _instance;
  }

  NodeRedService._singletonConstractor();

  static final NodeRedService _instance =
      NodeRedService._singletonConstractor();

  NodeRedAPI nodeRedApi = NodeRedAPI();

  /// Install node module if not exist and set a new flow for that api
  /// Label is name of the flow
  Future<String> setFlowWithModule({
    required String moduleToUse,
    required String label,
    required String nodes,
    required String flowId,
  }) async {
    // TODO: check if crash when trying to download new node inside node red without internet connection

    try {
      /// Install the new node module
      await nodeRedApi.postNodes(moduleToUse);

      final Response response = await nodeRedApi.postFlow(
        label: label,
        nodes: nodes,
        flowId: flowId,
      );
      if (response.statusCode != 200) {
        print('Error sending nodeRED flow request\n${response.body}');
      }
      // ignore: avoid_dynamic_calls
      final String returnedFlowId = jsonDecode(response.body)['id'] as String;
      return returnedFlowId;
    } catch (e) {
      if (e.toString() ==
          'The remote computer refused the network connection.\r\n') {
        print('Node-RED is not installed');
      } else {
        print('Node-RED setting flow with module $moduleToUse\n$e');
      }
    }
    return "";
  }

  /// Update existing flow with more nodes
  Future<String> updateFlowNodes({
    required String nodes,
    required String flowId,
  }) async {
    try {
      final Response response = await nodeRedApi.putFlowById(
        nodes: nodes,
        flowId: flowId,
      );
      if (response.statusCode != 200) {
        print('Error updating nodeRED flow node request\n${response.body}');
      }
    } catch (e) {
      print('Node-RED updating flow\n$e');
    }
    return "";
  }

  /// Install node module if needed and set one global node
  /// Label is name of the flow
  Future<String> setGlobalNodes({
    required String? moduleToUse,
    required String nodes,
  }) async {
    try {
      /// Install the new node module
      if (moduleToUse != null) {
        await nodeRedApi.postNodes(moduleToUse);
      }
      final Response response = await nodeRedApi.postGlobalNode(nodes);
      if (response.statusCode != 200) {
        print('Error sending nodeRED global node request\n${response.body}');
      }
    } catch (e) {
      print('Node-RED setting global node with module $moduleToUse\n$e');
      return e.toString();
    }
    return "ok";
  }

  Future<Response> postFlow({
    required String label,
    required String nodes,
    String? flowId,
    List<dynamic>? configs,
  }) =>
      nodeRedApi.postFlow(
        label: label,
        nodes: nodes,
        flowId: flowId,
        configs: configs,
      );

  Future<Response> deleteFlowById(String id) => nodeRedApi.deleteFlowById(id);
}
