import 'dart:ui';
import 'package:flutter/material.dart';

class TranslucentBackground extends StatelessWidget {
  const TranslucentBackground(
      {Key? key, this.child, this.blurFilter = const [4, 4]})
      : super(key: key);
  final Widget? child;
  final List<double> blurFilter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/auth_background.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: blurFilter[0], sigmaY: blurFilter[1]),
          child: Align(
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      ],
    );
  }
}
