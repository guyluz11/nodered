import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_visual_node_abstract.dart';

class NodeRedHttpInNode extends NodeRedVisualNodeAbstract {
  NodeRedHttpInNode({
    super.tempId,
    super.name,
    super.wires,
    required this.url,
    required this.method,
  }) : super(
          type: 'http in',
        );

  final String url;
  final NodeRedHttpMethod method;

  @override
  String toString() {
    return '''
    {
    "id": "$id",
    "type": "$type",
    "name": "$name",
    "url": "$url",
    "method": "${method.name}",
    "upload": false,
    "x": 600,
    "y": 400,
    "wires":  ${fixWiresString()}
  }''';
  }
}

enum NodeRedHttpMethod {
  post,
  get,
  put,
  delete,
  patch,
}
