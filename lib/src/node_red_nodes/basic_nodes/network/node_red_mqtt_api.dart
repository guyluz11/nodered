import 'package:nodered/nodered.dart';

class NodeRedMqttApi {
  NodeRedMqttApi({required this.repository, this.brokerId});

  final NodeRedService repository;
  String? brokerId;

  static final String baseTopic = 'nodeRed';

  Future<String> createBroker(String name) async {
    String nodes = '[\n';

    /// Mqtt broker
    final NodeRedMqttBrokerNode mqttBrokerNode =
        NodeRedMqttBrokerNode(name: name);

    nodes += '$mqttBrokerNode';

    nodes += '\n]';

    /// Setting the flow
    await repository.setGlobalNodes(nodes: nodes);
    return mqttBrokerNode.id;
  }
}
