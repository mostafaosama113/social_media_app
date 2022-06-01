import 'package:flutter/cupertino.dart';

class SlideRight extends PageRouteBuilder {
  final Widget screen;
  SlideRight({required this.screen})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (
            context,
            animation,
            animationTwo,
          ) =>
              screen,
          transitionsBuilder: (
            context,
            animation,
            animationTwo,
            child,
          ) {
            var tween = Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            );
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              child: child,
              position: offsetAnimation,
            );
          },
        );
}
