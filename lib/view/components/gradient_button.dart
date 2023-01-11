import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    super.key,
    required this.onPressed,
    required this.borderRadius,
    required this.gradient,
    required this.child,
  });

  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final Gradient gradient;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(150),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: child,
        ),
      ),
    );
  }
}
