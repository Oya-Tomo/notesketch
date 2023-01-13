import 'package:flutter/material.dart';

class NotePageBatch extends StatelessWidget {
  const NotePageBatch({super.key, required this.title, required this.color});
  final String title;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
