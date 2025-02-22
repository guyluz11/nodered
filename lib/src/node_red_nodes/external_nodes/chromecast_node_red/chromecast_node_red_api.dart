import 'package:nodered/nodered.dart';

class ChromecastNodeRedApi {
  ChromecastNodeRedApi({
    required this.repository,
    required this.nodeRedApiBaseTopic,
    required this.nodeRedDevicesTopic,
    required this.brokerNodeId,
  });

  final NodeRedService repository;
  final String nodeRedApiBaseTopic;
  final String nodeRedDevicesTopic;
  final String brokerNodeId;

  final String module = 'node-red-contrib-castv2';

  final String youtubeVideoTopicProperty = 'youtubeVideo';
  final String playingVideoTopicProperty = 'playingVideo';
  final String pauseVideoTopicProperty = 'pauseVideo';
  final String stopVideoTopicProperty = 'stopVideo';
  final String playVideoTopicProperty = 'playVideo';
  final String queuePrevVideoTopicProperty = 'queuePrevVideo';
  final String queueNextVideoTopicProperty = 'queueNextVideo';
  final String closeAppTopicProperty = 'closeApp';
  final String outputVideoTopicProperty = 'outputVideo';

  Future<String> setNewYoutubeVideoNodes(
    String entityUniqueId,
    String deviceIp,
    String mqttBrokerNodeId,
  ) async {
    String nodes = '[\n';

    const String mqttNodeName = 'Chromecast';

    final String topic =
        '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/$entityUniqueId/$youtubeVideoTopicProperty';

    /// Mqtt out

    final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
      brokerNodeId: brokerNodeId,
      topic: '$topic/$outputVideoTopicProperty',
      name: '$mqttNodeName - $outputVideoTopicProperty',
    );
    nodes += '$mqttNode';

    /// Cast v2 connection
    final NodeRedCastV2ConnectionNode nodeRedCastV2ConnectionNode =
        NodeRedCastV2ConnectionNode(host: deviceIp);
    nodes += ', $nodeRedCastV2ConnectionNode';

    /// Cast v2 sender
    final NodeRedCastV2SenderNode nodeRedCastV2SenderNode =
        NodeRedCastV2SenderNode(
      connectionId: nodeRedCastV2ConnectionNode.id,
      wires: {
        {
          mqttNode.id,
        },
      },
    );
    nodes += ', $nodeRedCastV2SenderNode';

    nodes += ', ${_openUrlNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_stopVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_pauseVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_playVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_queuePrevVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_queueNextVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += ', ${_closeVideoNodesString(
      brokerNodeId,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      topic,
    )}';

    nodes += '\n]';

    /// Setting the flow
    return repository.setFlowWithModule(
      moduleToUse: module,
      label: 'playYoutubeUrl',
      nodes: nodes,
      flowId: '$entityUniqueId-YoutubeVideo',
    );
  }

  String _openUrlNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"app\\\\\\": \\\\\\"YouTube\\\\\\", \\\\\\"type\\\\\\": \\\\\\"MEDIA\\\\\\",\\\\\\"videoId\\\\\\": \\\\\\"\\" + msg.payload + \\"\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $playingVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$playingVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _stopVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"STOP\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $stopVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$stopVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _pauseVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PAUSE\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $pauseVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$pauseVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _playVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PLAY\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $playVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$playVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _queuePrevVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_PREV\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $queuePrevVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$queuePrevVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _queueNextVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_NEXT\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $queueNextVideoTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$queueNextVideoTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String _closeVideoNodesString(
    String brokerNodeId,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"CLOSE\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: {
        {
          nextNodeIdToConnectToo,
        },
      },
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $closeAppTopicProperty',
      brokerNodeId: brokerNodeId,
      topic: '$topic/$closeAppTopicProperty',
      wires: {
        {
          nodeRedFunctionNode.id,
        },
      },
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }
}
