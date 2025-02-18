import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_visual_node_abstract.dart';

class NodeRedMatterManagerNode extends NodeRedVisualNodeAbstract {
  NodeRedMatterManagerNode({
    required this.controller,
    required this.deviceName,
    required this.cluster,
    required this.command,
    super.name,
  }) : super(
          type: 'mattercommand',
        );

  final String controller;
  final String deviceName;
  final NodeRedMatterCommandClusterEnum cluster;
  final NodeRedMatterCommandCommandEnum command;

  @override
  String toString() {
    return '''
    {
    "id": "$id",
    "type": "$type",
    "name": "$name",
    "controller": "$controller",
    "device": "17174800272800391268-1",
    "deviceName": "$deviceName",
    "command": "${command.name}",
    "cluster": "${cluster.asNumber}",
    "data": "{}",
    "dataType": "json",
    "simpleMode": true,
    "wires":  ${fixWiresString()}
    }
    ''';
  }
}

enum NodeRedMatterCommandClusterEnum {
  onOff(6),
  ;

  const NodeRedMatterCommandClusterEnum(this.asNumber);
  final int asNumber;
}

enum NodeRedMatterCommandCommandEnum {
  toggle,
  ;
}
