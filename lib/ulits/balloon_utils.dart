import 'package:flutter/material.dart';

class BalloonUtils {
  static Widget buildBalloon({
    required Color color,
    double scale = 1.0,
    bool withString = true,
    double windEffect = 0.0,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100 * scale,
          height: 120 * scale,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [color.withOpacity(0.8), color],
              center: const Alignment(0.3, -0.5),
            ),
            borderRadius: BorderRadius.circular(50 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10 * scale,
                offset: Offset(10 * scale, 10 * scale),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Balloon highlight
              Positioned(
                top: 10 * scale,
                left: 20 * scale,
                child: Container(
                  width: 30 * scale,
                  height: 20 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (withString)
          SizedBox(
            width: 100 * scale,
            height: 60 * scale,
            child: CustomPaint(
              painter: BalloonString(
                scale: scale,
                windEffect: windEffect,
              ),
            ),
          ),
      ],
    );
  }
}

class BalloonString extends CustomPainter {
  final double scale;
  final double windEffect;

  BalloonString({
    this.scale = 1.0,
    this.windEffect = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0 * scale
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Start point (top of string)
    path.moveTo(size.width / 2, 0);

    // Control points for the bezier curve
    final controlPoint1 =
        Offset(size.width / 2 + (30 * windEffect), size.height / 3);
    final controlPoint2 =
        Offset(size.width / 2 - (20 * windEffect), size.height * 2 / 3);
    final endPoint = Offset(size.width / 2, size.height);

    // Draw the curved string
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
