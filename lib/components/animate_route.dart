import 'package:flutter/material.dart';

Route animatedDart(Widget destinationWidget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinationWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 1000),
  );
}
