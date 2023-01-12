import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotePageBatch extends StatelessWidget {
  const NotePageBatch({super.key, required this.title, required this.color});
  final String title;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(title),
    );
  }
}
