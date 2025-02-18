import 'package:http/src/response.dart';
import 'package:nodered/nodered.dart';
import 'package:nodered/src/utils.dart';
import 'package:uuid/uuid.dart';

/// Mqtt example, MqttInNode -> functionNode -> MqttOut
Future<void> main() async {
  NodeRedService service = NodeRedService();
  logger.i('IP ${service.nodeRedApi.address} port ${service.nodeRedApi.port}');
  final NodeRedMqttBrokerNode brokerNode =
      NodeRedMqttBrokerNode(name: 'CyBear  Jinni Broker');

  String nodes = '';
  nodes += brokerNode.toString();
  nodes += ', ';

  final String topic = 'BaseTopic/TopicTypeName/uniqueId/on';
  final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
    brokerNodeId: brokerNode.id,
    topic: topic,
    name: 'deviceName - on',
  );
  nodes += mqttNode.toString();
  nodes += ', ';

  final NodeRedFunctionNode functionForNode =
      NodeRedFunctionNode.passOnlyNewAction(
    action: 'on',
    name: 'functionNode',
    wires: {
      {
        mqttNode.id,
      },
    },
  );

  nodes += functionForNode.toString();
  nodes += ', ';

  final String mqttInNodeId = const Uuid().v1();
  final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
    name: 'mqttIn',
    brokerNodeId: brokerNode.id,
    topic: topic,
    wires: {
      {functionForNode.id}
    },
    tempId: mqttInNodeId,
  );

  nodes += nodeRedMqttInNode.toString();

  nodes = '[\n$nodes\n]';

  Response response =
      await service.postFlow(label: 'Example Flow', nodes: nodes);

  logger.i('Done response $response');
}
