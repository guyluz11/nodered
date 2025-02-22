import 'package:nodered/nodered.dart';
import 'package:nodered/src/node_red_nodes/external_nodes/matter_node_red_nodes/matter_nodes/node_red_matter_manager_node.dart';

import 'matter_nodes/node_red_matter_controller_node.dart';

class MatterNodeRedApi {
  MatterNodeRedApi({
    required this.repository,
    required this.nodeRedApiBaseTopic,
    required this.nodeRedDevicesTopic,
    required this.brokerNodeId,
  });

  final NodeRedService repository;
  final String nodeRedApiBaseTopic;
  final String nodeRedDevicesTopic;
  final String brokerNodeId;

  static final String module = '@sammachin/node-red-matter-controller';

  final String listMatterOutTopic = 'listDevicesMatterOut';
  final String listMatterInTopic = 'listDevicesMatterIn';

  final String getMatterOutTopic = 'getDeviceMatterOut';
  final String getMatterInTopic = 'getDeviceMatterIn';

  /// Only one controller instance is needed
  Future<String> createController() async {
    String nodes = '';
    NodeRedMatterControllerNode controllerNode = NodeRedMatterControllerNode();

    nodes += '$controllerNode';

    nodes = '[\n$nodes\n]';

    /// Setting the flow
    repository.setGlobalNodes(
      moduleToUse: module,
      nodes: nodes,
    );
    return controllerNode.id;
  }

  Future addListDevicesManager({
    required String controllerId,
    String deviceName = 'listDevices',
  }) async {
    String nodes = '';

    nodes +=
        _listDevicesNode(controllerId: controllerId, deviceName: deviceName);

    nodes +=
        ', ${_getDevicesNode(controllerId: controllerId, deviceName: deviceName)}';

    nodes = '[\n$nodes\n]';

    /// Setting the flow
    return repository.setFlowWithModule(
      moduleToUse: module,
      label: 'Matter Devices',
      nodes: nodes,
      flowId: 'matter_controller',
    );
  }

  /// Nodes for listing all the matter devices Id
  String _listDevicesNode({
    required String controllerId,
    String deviceName = 'listDevices',
  }) {
    String nodes = '';

    /// Mqtt out
    final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
      brokerNodeId: brokerNodeId,
      topic: '${NodeRedMqttApi.baseTopic}/$listMatterOutTopic',
      name: 'List Matter Out',
    );
    nodes += '$mqttNode';

    NodeRedMatterManagerNode listDevices = NodeRedMatterManagerNode(
      controller: controllerId,
      deviceName: deviceName,
      method: NodeRedMatterManagerMethodEnum.listDevices,
      name: 'List Matter Devices',
      wires: {
        {mqttNode.id}
      },
    );

    nodes += ', $listDevices';

    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: 'List Matter In',
      brokerNodeId: brokerNodeId,
      topic: '${NodeRedMqttApi.baseTopic}/$listMatterInTopic',
      wires: {
        {
          listDevices.id,
        },
      },
    );
    nodes += ', $nodeRedMqttInNode';
    return nodes;
  }

  /// Node for getting matter device id and returning information about it
  String _getDevicesNode({
    required String controllerId,
    String deviceName = 'listDevices',
  }) {
    String nodes = '';

    /// Mqtt out
    final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
      brokerNodeId: brokerNodeId,
      topic: '${NodeRedMqttApi.baseTopic}/$getMatterOutTopic',
      name: 'Get Matter Out',
    );
    nodes += '$mqttNode';

    NodeRedMatterManagerNode getDevices = NodeRedMatterManagerNode(
      controller: controllerId,
      deviceName: deviceName,
      method: NodeRedMatterManagerMethodEnum.getDevice,
      name: 'Get Matter Devices',
      wires: {
        {mqttNode.id}
      },
    );

    nodes += ', $getDevices';

    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: 'Get Matter In',
      brokerNodeId: brokerNodeId,
      topic: '${NodeRedMqttApi.baseTopic}/$getMatterInTopic',
      wires: {
        {getDevices.id}
      },
    );
    nodes += ', $nodeRedMqttInNode';
    return nodes;
  }
}
