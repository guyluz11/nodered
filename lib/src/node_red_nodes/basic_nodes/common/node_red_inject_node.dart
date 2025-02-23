import 'package:nodered/src/node_red_nodes/basic_nodes/node_red_visual_node_abstract.dart';
import 'package:nodered/src/utils.dart';

class NodeRedInjectNode extends NodeRedVisualNodeAbstract {
  NodeRedInjectNode({
    this.daysToRepeat,
    this.hourToRepeat,
    this.minutesToRepeat,
    this.props = const [],
    super.tempId,
    super.name,
    super.wires,
  }) : super(
          type: 'inject',
        );

  Set<String>? daysToRepeat;
  String? hourToRepeat;
  String? minutesToRepeat;
  List<InjectNodeProp> props;

  @override
  String toString() {
    String propsAsString = '';

    for (InjectNodeProp p in props) {
      if (propsAsString.isNotEmpty) {
        propsAsString += ',\n';
      }
      propsAsString += p.toString();
    }

    if (daysToRepeat != null ||
        hourToRepeat != null ||
        minutesToRepeat != null) {
      final String crontab =
          '$minutesToRepeat $hourToRepeat * * ${daysToRepeatAsCornTabRequire()}';

      return '''
        {
          "id": "$id",
          "type": "$type",
          "name": "$name",
          "props": [\n$propsAsString\n],
          "repeat": "",
          "crontab": "$crontab",
          "once": false,
          "onceDelay": 0.1,
          "x": 400,
          "y": 800,
          "topic": "",
          "wires":  ${fixWiresString()}
        }''';
    }

    return '''
      {
        "id": "$id",
        "type": "$type",
        "name": "$name",
        "props": [\n$propsAsString\n],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "x": 400,
        "y": 800,
        "wires":  ${fixWiresString()}
      }''';
  }

  String daysToRepeatAsCornTabRequire() {
    if (daysToRepeat!.length >= 7) {
      return '*';
    }
    String daysToRepeatTemp = '';

    for (final String dayToRepeat in daysToRepeat!) {
      if (daysToRepeatTemp != '') {
        daysToRepeatTemp += ',';
      }

      if (dayToRepeat == 'sunday') {
        daysToRepeatTemp += '0';
      } else if (dayToRepeat == 'monday') {
        daysToRepeatTemp += '1';
      } else if (dayToRepeat == 'tuesday') {
        daysToRepeatTemp += '2';
      } else if (dayToRepeat == 'wednesday') {
        daysToRepeatTemp += '3';
      } else if (dayToRepeat == 'thursday') {
        daysToRepeatTemp += '4';
      } else if (dayToRepeat == 'friday') {
        daysToRepeatTemp += '5';
      } else if (dayToRepeat == 'saturday') {
        daysToRepeatTemp += '6';
      } else {
        daysToRepeatTemp += 'Error';
        logger.e('Day does not exist');
      }
    }
    return daysToRepeatTemp;
  }
}

class InjectNodeProp {
  InjectNodeProp({
    required this.p,
    this.vt,
    this.v,
  });

  final String p;
  final VtTypes? vt;
  final String? v;

  @override
  String toString() {
    String vAsString = '';
    if (v != null) {
      vAsString = ',\n"v": "$v"';
    }

    String vtAsString = '';
    if (vt != null) {
      vtAsString = ',\n"vt": "${vt!.name}"';
    }

    return '''
    {
      "p": "$p"
      $vAsString
      $vtAsString
    }
    ''';
  }
}

enum VtTypes {
  msg,
  str,
  json,

  /// this is time stamp
  date,
}
