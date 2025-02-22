import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_visual_node_abstract.dart';

class NodeRedMatterManagerNode extends NodeRedVisualNodeAbstract {
  NodeRedMatterManagerNode({
    required this.controller,
    required this.deviceName,
    required this.method,
    this.label = '',
    this.code = '',
    super.name,
    super.wires,
  }) : super(
          type: 'mattermanager',
        );

  final String controller;
  final String deviceName;
  final String code;

  /// Device name
  final String label;
  final NodeRedMatterManagerMethodEnum method;
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
    "deviceidType": "msg",
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
  getDevice,
  renameDevice,
  ;
}
