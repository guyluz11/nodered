import 'dart:convert';

import 'package:http/http.dart';
import 'package:nodered/nodered.dart';
import 'package:nodered/src/utils.dart';

/// Mqtt example, MqttInNode -> functionNode -> MqttOut
Future<void> main() async {
  NodeRedService service = NodeRedService();
  logger.i('IP ${service.nodeRedApi.address} port ${service.nodeRedApi.port}');

  NodeRedMqttApi nodeRedMqttApi = NodeRedMqttApi(repository: service);
  String brokerNodeId = await nodeRedMqttApi.createBroker('BrokerNode');

  ChromecastNodeRedApi matterNode = ChromecastNodeRedApi(
    repository: service,
    nodeRedApiBaseTopic: 'exampleTopic',
    nodeRedDevicesTopic: 'devicesTopic',
    brokerNodeId: brokerNodeId,
  );

  String response = await matterNode.setNewYoutubeVideoNodes(
    'testDevice',
    '10.0.0.1',
    brokerNodeId,
  );

  String castSenderNodeId =
      ManageNodes.addedNodes[NodeTypes.castSender]?.id ?? '';
  final url = Uri.parse('http://localhost:1880/$castSenderNodeId');

  try {
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"payload": castSenderNodeId}),
    );
    logger.i(response.statusCode);
  } catch (e) {}

  logger.i('Done response $response');
}
