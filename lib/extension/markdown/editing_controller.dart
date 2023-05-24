import 'package:flutter/material.dart';
import 'package:notesketch/extension/markdown/highlight_theme.dart';
import 'package:notesketch/extension/markdown/parser.dart';

class MdHighLightTextEditingController extends TextEditingController {
  final _parser = MarkdownParser();

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final parsedLines = _parser.parse(text);

    List<TextSpan> textSpans = [];

    for (int i = 0; i < parsedLines.length; i++) {
      final line = parsedLines[i];
      textSpans.add(TextSpan(
        children: line.blocks.map((block) {
          return TextSpan(
            text: block.text,
            style: markdownTheme[line.type]![block.type],
          );
        }).toList(),
      ));
      if (i != parsedLines.length - 1) {
        textSpans.add(
          TextSpan(
            text: "\n",
            style: markdownTheme[line.type]![line.blocks.last.type],
          ),
        );
      }
    }

    return TextSpan(children: textSpans);
  }
}
