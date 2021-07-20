import 'package:flutter/material.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;

/* 
Background circle painter
WIP
 */
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();


    Path circularPath = Path();
    circularPath.moveTo(width / 2, 0);
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this; // prevent re-rendering
  }
}
