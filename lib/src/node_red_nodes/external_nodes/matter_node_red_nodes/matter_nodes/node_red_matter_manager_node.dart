import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_visual_node_abstract.dart';

class NodeRedMatterManagerNode extends NodeRedVisualNodeAbstract {
  NodeRedMatterManagerNode({
    required this.controller,
    required this.deviceName,
    required this.cluster,
    required this.code,
    required this.attr,
    required this.method,
    required this.label,
    super.name,
  }) : super(
          type: 'mattermanager',
        );

  final String controller;
  final String deviceName;
  final String code;
  final String attr;

  /// Device name
  final String label;
  final NodeRedMatterManagerMethodEnum method;
  final int cluster;

  @override
  String toString() {
    return '''
    {
    "id": "$id",
    "type": "$type",
    "name": "$name",
    "controller": "$controller",
    "method": "${method.name}",
    "code": "$code",
    "codeType": "str",
    "deviceidType": "str",
    "label": "$label",
    "labelType": "str",
    "wires":  ${fixWiresString()}
    }
    
    ''';
  }
}

enum NodeRedMatterManagerMethodEnum {
  commissionDevice,
  decommissionDevice,
  openCommissioningWindow,
  listDevices,
  getDevices,
  renameDevice,
  ;
}
