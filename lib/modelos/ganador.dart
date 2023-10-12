import 'package:banquero/modelos/draw.dart';
import 'package:banquero/modelos/lottery.dart';
import 'package:banquero/modelos/number.dart';

class Ganador {
  final Lottery lottery;
  final Draw draw;
  final Number number;

  Ganador({
    required this.lottery,
    required this.draw,
    required this.number,
  });
  Map<String, dynamic> toJson() {
    return {
      'lottery': lottery,
      'draw': draw,
      'number': number,
    };
  }
}
