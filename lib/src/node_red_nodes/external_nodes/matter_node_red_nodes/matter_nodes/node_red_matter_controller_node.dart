import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_node_abstract.dart';

class NodeRedMatterControllerNode extends NodeRedNodeAbstract {
  NodeRedMatterControllerNode()
      : super(
          type: 'mattercontroller',
        );

  @override
  String toString() {
    return '''
    {
    "id": "$id",
    "type": "$type"
    }
    ''';
  }
}
