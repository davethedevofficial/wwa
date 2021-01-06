import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';

class WWACircleLoaderPainter extends CustomPainter {
  final double percent;
  bool clockwise = false;
  bool filled = false;
  bool exact = false;
  Color color;

  WWACircleLoaderPainter(this.percent,
      {this.clockwise = false,
      this.filled = false,
      this.exact = false,
      this.color})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = this.color == null ? primaryColor : this.color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = exact ? 0 : 5
      ..strokeCap = StrokeCap.round;

    //draw arc
    canvas.drawArc(
      Offset((exact ? 0 : -2.5), (exact ? 0 : -2.5)) &
          Size(size.width + (exact ? 0 : 5), size.height + (exact ? 0 : 5)),
      radians(-90), //radians
      radians(360 * this.percent * (clockwise ? -1 : 1)), //radians
      filled,
      paint1,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
