import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/pages/main_page.dart';
import 'package:notesketch/res/color_theme.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteSketch",
      theme: theme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
