import 'package:nodered/nodered.dart';
import 'package:nodered/src/utils.dart';

Future<void> main() async {
  NodeRedService service = NodeRedService();
  logger.i('IP ${service.nodeRedApi.address} port ${service.nodeRedApi.port}');

  NodeRedMqttApi nodeRedMqttApi = NodeRedMqttApi(repository: service);

  String brokerNodeId = await nodeRedMqttApi.createBroker('BrokerNode');

  MatterNodeRedApi matterNode = MatterNodeRedApi(
    repository: service,
    nodeRedApiBaseTopic: 'exampleTopic',
    nodeRedDevicesTopic: 'devicesTopic',
    brokerNodeId: brokerNodeId,
  );

  String matterControllerId = await matterNode.createController();

  matterNode.addListDevicesManager(
    controllerId: matterControllerId,
  );

  matterNode.addListDevicesManager(
    controllerId: matterControllerId,
  );

  // TODO: create a flow for each new devices that got discovered
}
