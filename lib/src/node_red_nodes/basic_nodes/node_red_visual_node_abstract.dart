import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_node_abstract.dart';

/// Abstract calss for all the nodes that can be connected on the dashboard

class NodeRedVisualNodeAbstract extends NodeRedNodeAbstract {
  NodeRedVisualNodeAbstract({
    required super.type,
    super.tempId,
    super.name,
    this.wires,
  });

  // Does not exists in all nodes, maybe we will move it to another abstract class
  Set<Set<String>>? wires = {};

  String fixWiresString() =>
      fixWiresForNodeRed().toString().replaceAll('{', '[').replaceAll('}', ']');

  fixWiresForNodeRed() {
    final Set<Set<String>> wiresTemp = {};

    // '"${mqttNode.id}"'
    if (wires != null) {
      for (final Set<String> tempWire in wires!) {
        final Set<String> fixedWireList = {};
        for (final String tempId in tempWire) {
          if (!tempId.contains('"')) {
            fixedWireList.add('"$tempId"');
          } else {
            fixedWireList.add(tempId);
          }
        }
        wiresTemp.add(fixedWireList);
      }
    }
    return wiresTemp;
  }
}
