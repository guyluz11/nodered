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
  logger.i('Done response $response');
}
