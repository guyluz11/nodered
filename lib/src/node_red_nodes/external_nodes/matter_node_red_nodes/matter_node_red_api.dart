// import 'package:nodered/nodered.dart';
//
// class ChromecastNodeRedApi {
//   ChromecastNodeRedApi({
//     required this.repository,
//     required this.nodeRedApiBaseTopic,
//     required this.nodeRedDevicesTopic,
//     this.nodeRedMqttBrokerNodeName = 'NodeRed plugs Api Broker',
//   });
//
//   final NodeRedService repository;
//   final String nodeRedApiBaseTopic;
//   final String nodeRedDevicesTopic;
//   final String nodeRedMqttBrokerNodeName;
//
//   final String module = '@sammachin/node-red-matter-controller';
//
//   final String youtubeVideoTopicProperty = 'youtubeVideo';
//   final String playingVideoTopicProperty = 'playingVideo';
//   final String pauseVideoTopicProperty = 'pauseVideo';
//   final String stopVideoTopicProperty = 'stopVideo';
//   final String playVideoTopicProperty = 'playVideo';
//   final String queuePrevVideoTopicProperty = 'queuePrevVideo';
//   final String queueNextVideoTopicProperty = 'queueNextVideo';
//   final String closeAppTopicProperty = 'closeApp';
//   final String outputVideoTopicProperty = 'outputVideo';
//
//   Future<String> setNewYoutubeVideoNodes(
//     String entityUniqueId,
//     String deviceIp,
//   ) async {
//     String nodes = '[\n';
//
//     const String mqttNodeName = 'Chromecast';
//
//     final String topic =
//         '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/$entityUniqueId/$youtubeVideoTopicProperty';
//
//     /// Mqtt broker
//     final NodeRedMqttBrokerNode mqttBrokerNode =
//         NodeRedMqttBrokerNode(name: nodeRedMqttBrokerNodeName);
//
//     nodes += mqttBrokerNode.toString();
//
//     /// Mqtt out
//
//     final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$outputVideoTopicProperty',
//       name: '$mqttNodeName - $outputVideoTopicProperty',
//     );
//     nodes += ', $mqttNode';
//
//     /// Cast v2 connection
//     final NodeRedCastV2ConnectionNode nodeRedCastV2ConnectionNode =
//         NodeRedCastV2ConnectionNode(host: deviceIp);
//     nodes += ', $nodeRedCastV2ConnectionNode';
//
//     /// Cast v2 sender
//     final NodeRedCastV2SenderNode nodeRedCastV2SenderNode =
//         NodeRedCastV2SenderNode(
//       connectionId: nodeRedCastV2ConnectionNode.id,
//       wires: {
//         {
//           mqttNode.id,
//         },
//       },
//     );
//     nodes += ', $nodeRedCastV2SenderNode';
//
//     nodes += ', ${openUrlNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${stopVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${pauseVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${playVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${queuePrevVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${queueNextVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += ', ${closeVideoNodesString(
//       mqttBrokerNode,
//       nodeRedCastV2SenderNode.id,
//       mqttNodeName,
//       topic,
//     )}';
//
//     nodes += '\n]';
//
//     /// Setting the flow
//     return repository.setFlowWithModule(
//       moduleToUse: module,
//       label: 'playYoutubeUrl',
//       nodes: nodes,
//       flowId: '$entityUniqueId-YoutubeVideo',
//     );
//   }
//
//   String openUrlNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"app\\\\\\": \\\\\\"YouTube\\\\\\", \\\\\\"type\\\\\\": \\\\\\"MEDIA\\\\\\",\\\\\\"videoId\\\\\\": \\\\\\"\\" + msg.payload + \\"\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $playingVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$playingVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String stopVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"STOP\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $stopVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$stopVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String pauseVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PAUSE\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $pauseVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$pauseVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String playVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PLAY\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $playVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$playVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String queuePrevVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_PREV\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $queuePrevVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$queuePrevVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String queueNextVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_NEXT\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $queueNextVideoTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$queueNextVideoTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
//
//   String closeVideoNodesString(
//     NodeRedMqttBrokerNode mqttBrokerNode,
//     String nextNodeIdToConnectToo,
//     String mqttNodeName,
//     String topic,
//   ) {
//     String nodes = '';
//
//     /// Function node
//     const String functionString =
//         '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"CLOSE\\\\\\"}\\"); return msg;''';
//     final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
//       funcString: functionString,
//       wires: {
//         {
//           nextNodeIdToConnectToo,
//         },
//       },
//     );
//     nodes += nodeRedFunctionNode.toString();
//
//     /// Mqtt in
//     final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
//       name: '$mqttNodeName - $closeAppTopicProperty',
//       brokerNodeId: mqttBrokerNode.id,
//       topic: '$topic/$closeAppTopicProperty',
//       wires: {
//         {
//           nodeRedFunctionNode.id,
//         },
//       },
//     );
//     return '$nodes,\n$nodeRedMqttInNode';
//   }
// }
