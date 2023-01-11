import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  const GradientDivider({super.key, required this.gradient});
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}
