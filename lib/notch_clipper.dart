import 'dart:math';

import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  final int position;
  final int totalStop;
  final Size notchSize;

  NotchClipper({
    this.totalStop = 2,
    this.position = 1,
    this.notchSize = const Size(30.0, 30.0),
  });

  @override
  Path getClip(Size size) {
    final partitionWidth = size.width / totalStop;
    final centerPoint = Offset(
      partitionWidth * (position - 1) + partitionWidth / 2,
      0.0,
    );
    final path = Path();
    path.lineTo(centerPoint.dx - notchSize.width / 2 - 3.0, 0.0);
    path.arcTo(
      Rect.fromLTWH(
        centerPoint.dx - notchSize.width / 2 - 3.0,
        -notchSize.height / 2 - 3.0,
        notchSize.width + 6.0,
        notchSize.height + 6.0,
      ),
      pi,
      -pi,
      true,
    );
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
