import 'package:flutter/material.dart';
import 'package:notesketch/extension/markdown/parser.dart';

final markdownTheme = {
  LineType.h1: {
    BlockType.symbol: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 50, 200, 100),
    ),
    BlockType.text: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 50, 200, 100),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 50, 200, 100),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 50, 200, 100),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 50, 200, 100),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.h2: {
    BlockType.symbol: const TextStyle(
      fontSize: 19.5,
      color: Color.fromARGB(255, 50, 180, 120),
    ),
    BlockType.text: const TextStyle(
      fontSize: 19.5,
      color: Color.fromARGB(255, 50, 180, 120),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 19.5,
      color: Color.fromARGB(255, 50, 180, 120),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 19.5,
      color: Color.fromARGB(255, 50, 180, 120),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 19.5,
      color: Color.fromARGB(255, 50, 180, 120),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.h3: {
    BlockType.symbol: const TextStyle(
      fontSize: 19,
      color: Color.fromARGB(255, 50, 160, 140),
    ),
    BlockType.text: const TextStyle(
      fontSize: 19,
      color: Color.fromARGB(255, 50, 160, 140),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 19,
      color: Color.fromARGB(255, 50, 160, 140),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 19,
      color: Color.fromARGB(255, 50, 160, 140),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 19,
      color: Color.fromARGB(255, 50, 160, 140),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.h4: {
    BlockType.symbol: const TextStyle(
      fontSize: 18.5,
      color: Color.fromARGB(255, 50, 140, 160),
    ),
    BlockType.text: const TextStyle(
      fontSize: 18.5,
      color: Color.fromARGB(255, 50, 140, 160),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 18.5,
      color: Color.fromARGB(255, 50, 140, 160),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 18.5,
      color: Color.fromARGB(255, 50, 140, 160),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 18.5,
      color: Color.fromARGB(255, 50, 140, 160),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.h5: {
    BlockType.symbol: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 120, 180),
    ),
    BlockType.text: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 120, 180),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 120, 180),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 120, 180),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 120, 180),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.h6: {
    BlockType.symbol: const TextStyle(
      fontSize: 17.5,
      color: Color.fromARGB(255, 50, 100, 200),
    ),
    BlockType.text: const TextStyle(
      fontSize: 17.5,
      color: Color.fromARGB(255, 50, 100, 200),
    ),
    BlockType.italic: const TextStyle(
      fontSize: 17.5,
      color: Color.fromARGB(255, 50, 100, 200),
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 17.5,
      color: Color.fromARGB(255, 50, 100, 200),
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 17.5,
      color: Color.fromARGB(255, 50, 100, 200),
      decoration: TextDecoration.underline,
    ),
  },
  LineType.list: {
    BlockType.symbol: const TextStyle(
      fontSize: 17,
      color: Color.fromARGB(255, 50, 200, 100),
      fontWeight: FontWeight.bold,
    ),
    BlockType.text: const TextStyle(
      fontSize: 17,
      color: Colors.white,
    ),
    BlockType.italic: const TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 17,
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
  },
  LineType.quote: {
    BlockType.symbol: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 160, 140),
      fontWeight: FontWeight.bold,
    ),
    BlockType.text: const TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    BlockType.italic: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
  },
  LineType.info: {
    BlockType.symbol: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 100, 200),
      fontWeight: FontWeight.bold,
    ),
    BlockType.text: const TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    BlockType.italic: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
  },
  LineType.text: {
    BlockType.symbol: const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 50, 200, 100),
      fontWeight: FontWeight.bold,
    ),
    BlockType.text: const TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    BlockType.italic: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    BlockType.bold: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    BlockType.link: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
  },
};
