import 'package:nodered/nodered.dart';
import 'package:nodered/src/node_red_nodes/basic_nodes/common/node_red_inject_node.dart';
import 'package:nodered/src/node_red_nodes/basic_nodes/network/node_red_http_in_node.dart';

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
    ManageNodes.addedNodes.addEntries([MapEntry(NodeTypes.mqttOut, mqttNode)]);

    /// Cast v2 connection
    final NodeRedCastV2ConnectionNode nodeRedCastV2ConnectionNode =
        NodeRedCastV2ConnectionNode(host: deviceIp, name: 'Connection');
    nodes += ', $nodeRedCastV2ConnectionNode';
    ManageNodes.addedNodes.addEntries(
        [MapEntry(NodeTypes.castConnection, nodeRedCastV2ConnectionNode)]);

    /// Cast v2 sender
    final NodeRedCastV2SenderNode nodeRedCastV2SenderNode =
        NodeRedCastV2SenderNode(
      name: 'Sender',
      connectionId: nodeRedCastV2ConnectionNode.id,
      wires: {
        {
          mqttNode.id,
        },
      },
    );
    nodes += ', $nodeRedCastV2SenderNode';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castSender, nodeRedCastV2SenderNode)]);

    NodeRedFunctionNode nodeRedFunctionNode =
        NodeRedFunctionNode.passOnlyNewAction(
      name: 'Open YouTube command',
      action:
          '{\\"app\\": \\"YouTube\\", \\"type\\": \\"MEDIA\\", \\"videoId\\": \\"\${msg.payload.payload || \\"\\"}\\"}',
      wires: {
        {nodeRedCastV2SenderNode.id},
      },
    );
    nodes += ', ${nodeRedFunctionNode.toString()}';

    /// Open Url of a video
    NodeRedHttpInNode nodeRedHttpInNode = NodeRedHttpInNode(
        name: 'Open YouTube URL',
        url: nodeRedCastV2SenderNode.id,
        method: NodeRedHttpMethod.post,
        wires: {
          {nodeRedFunctionNode.id},
        });

    nodes += ', ${nodeRedHttpInNode.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castOpenUrl, nodeRedHttpInNode)]);

    /// Stop Video
    NodeRedInjectNode stopInject = injectNodeWithAction(
        name: 'Stop',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"STOP\\"}');
    nodes += ', ${stopInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castStopInject, stopInject)]);

    /// Pause Video
    NodeRedInjectNode pauseInject = injectNodeWithAction(
        name: 'Pause',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"PAUSE\\"}');
    nodes += ', ${pauseInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castPauseInject, pauseInject)]);

    /// Play Video
    NodeRedInjectNode platInject = injectNodeWithAction(
        name: 'Play',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"PLAY\\"}');
    nodes += ', ${platInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castPlayInject, platInject)]);

    /// Queue Prev Video
    NodeRedInjectNode queuePrevInject = injectNodeWithAction(
        name: 'Queue Prev',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"QUEUE_PREV\\"}');
    nodes += ', ${queuePrevInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castQueuePrevInject, queuePrevInject)]);

    /// Queue Next Video
    NodeRedInjectNode queueNextInject = injectNodeWithAction(
        name: 'Queue Next',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"QUEUE_NEXT\\"}');
    nodes += ', ${queueNextInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castQueueNextInject, queueNextInject)]);

    /// Close Video command
    NodeRedInjectNode closeInject = injectNodeWithAction(
        name: 'Close',
        nodeRedCastV2SenderNodeId: nodeRedCastV2SenderNode.id,
        v: '{\\"type\\": \\"CLOSE\\"}');
    nodes += ', ${closeInject.toString()}';
    ManageNodes.addedNodes
        .addEntries([MapEntry(NodeTypes.castCloseInject, closeInject)]);

    nodes += '\n]';

    /// Setting the flow
    return repository.setFlowWithModule(
      moduleToUse: module,
      label: 'playYoutubeUrl',
      nodes: nodes,
      flowId: '$entityUniqueId-YoutubeVideo',
    );
  }

  NodeRedInjectNode injectNodeWithAction(
      {required String name,
      required String nodeRedCastV2SenderNodeId,
      required String v}) {
    return NodeRedInjectNode(
      name: name,
      props: [
        InjectNodeProp(p: 'payload', vt: VtTypes.json, v: v),
      ],
      wires: {
        {nodeRedCastV2SenderNodeId},
      },
    );
  }
}
