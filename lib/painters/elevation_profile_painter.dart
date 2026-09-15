import 'package:flutter/material.dart';

class ElevationProfilePainter extends CustomPainter {
  final List<double> elevations; // in meters

  ElevationProfilePainter({required this.elevations});

  @override
  void paint(Canvas canvas, Size size) {
    if (elevations.isEmpty) return;

    final minEle = elevations.reduce((a, b) => a < b ? a : b);
    final maxEle = elevations.reduce((a, b) => a > b ? a : b);
    final range = (maxEle - minEle == 0) ? 1.0 : (maxEle - minEle);

    final path = Path();
    final stepX = size.width / (elevations.length - 1);

    for (int i = 0; i < elevations.length; i++) {
      final normY = (elevations[i] - minEle) / range;
      final x = i * stepX;
      final y = size.height - (normY * (size.height * 0.75) + 15);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Line stroke
    final strokePaint = Paint()
      ..color = const Color(0xFF52B788)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, strokePaint);

    // Gradient fill beneath
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF52B788).withValues(alpha: 0.35), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant ElevationProfilePainter oldDelegate) => true;
}
