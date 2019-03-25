import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  final double centerX;
  final int totalStop;
  final Size notchSize;

  NotchClipper({
    this.totalStop = 2,
    this.centerX = 0.0,
    this.notchSize = const Size(30.0, 30.0),
  });

  @override
  Path getClip(Size size) {
    final partitionWidth = size.width / totalStop;
    final bezierLenght = notchSize.width / 2 + 10.0 + partitionWidth * 0.2;
    final centerPoint = Offset(
      centerX,
      notchSize.height + 10.0,
    );
    final startPoint = Offset(
      centerPoint.dx - bezierLenght,
      notchSize.height / 2,
    );
    final endPoint = Offset(
      centerPoint.dx + bezierLenght,
      notchSize.height / 2,
    );

    final controlPoint11 = Offset(
      startPoint.dx + bezierLenght * 0.5,
      startPoint.dy,
    );
    final controlPoint12 = Offset(
      centerPoint.dx - bezierLenght * 0.7,
      centerPoint.dy,
    );
    final controlPoint21 = Offset(
      endPoint.dx - bezierLenght * 0.5,
      startPoint.dy,
    );
    final controlPoint22 = Offset(
      centerPoint.dx + bezierLenght * 0.7,
      centerPoint.dy,
    );

    final path = Path();
    path.moveTo(0.0, notchSize.height / 2);
    path.lineTo(startPoint.dx, startPoint.dy);
    path.cubicTo(
      controlPoint11.dx,
      controlPoint11.dy,
      controlPoint12.dx,
      controlPoint12.dy,
      centerPoint.dx,
      centerPoint.dy,
    );
    path.cubicTo(
      controlPoint22.dx,
      controlPoint22.dy,
      controlPoint21.dx,
      controlPoint21.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, notchSize.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
