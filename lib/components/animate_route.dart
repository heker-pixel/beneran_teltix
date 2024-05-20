import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset begin;
  final Offset end;
  final Duration duration;

  CustomPageRoute({
    required this.page,
    required this.begin,
    required this.end,
    this.duration =
        const Duration(milliseconds: 300), // Atur durasi animasi default
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: duration, // Atur durasi transisi
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.ease));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
