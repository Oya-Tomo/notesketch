enum LineType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  text,
  list,
  quote,
  info,
}

enum BlockType {
  symbol,
  text,
  link,
  italic,
  bold,
}

class ParsedLine {
  ParsedLine({
    required this.type,
    required this.text,
    required this.blocks,
  });
  LineType type;
  String text;
  List<ParsedBlock> blocks;
}

class ParsedBlock {
  ParsedBlock({
    required this.type,
    required this.text,
  });
  BlockType type;
  String text;
}

class MarkdownParser {
  MarkdownParser();
  String parsedText = "";
  List<ParsedLine> parsedLines = [
    ParsedLine(
      type: LineType.text,
      text: "",
      blocks: [
        ParsedBlock(type: BlockType.text, text: ""),
      ],
    ),
  ];

  List<ParsedLine> parse(String text) {
    if (parsedText == text) {
      return parsedLines;
    } else {
      parsedText = text;
      parsedLines = text.split("\n").asMap().entries.map((entry) {
        return _parseLine(entry.key, entry.value);
      }).toList();
      return parsedLines;
    }
  }

  ParsedLine _parseLine(int index, String line) {
    if (line.isEmpty) {
      return ParsedLine(
        type: LineType.text,
        text: "",
        blocks: [
          ParsedBlock(
            type: BlockType.text,
            text: "",
          ),
        ],
      );
    }

    // check kept lines.
    if (0 <= index && index < parsedLines.length) {
      if (parsedLines[index].text == line) {
        return parsedLines[index];
      }
    }

    if (0 <= index + 1 && index + 1 < parsedLines.length) {
      if (parsedLines[index + 1].text == line) {
        return parsedLines[index + 1];
      }
    }

    if (0 <= index - 1 && index - 1 < parsedLines.length) {
      if (parsedLines[index - 1].text == line) {
        return parsedLines[index - 1];
      }
    }

    // search line
    final isHeader = _isHeaderLine(line);
    if (isHeader != null) {
      return isHeader;
    }

    final isList = _isListItemLine(line);
    if (isList != null) {
      return isList;
    }

    final isQuote = _isQuoteLine(line);
    if (isQuote != null) {
      return isQuote;
    }

    final isInfo = _isInfoLine(line);
    if (isInfo != null) {
      return isInfo;
    }

    return ParsedLine(
      type: LineType.text,
      text: line,
      blocks: [
        ..._parseText(line),
      ],
    );
  }

  ParsedLine? _isHeaderLine(String line) {
    final reg = RegExp("( *)(#{1,6})( +.*)");
    final res = reg.firstMatch(line);
    if (res == null) {
      return null;
    } else if (res.start == 0 && res.end == line.length) {
      return ParsedLine(
        type: [
          LineType.h1,
          LineType.h2,
          LineType.h3,
          LineType.h4,
          LineType.h5,
          LineType.h6,
        ][res.group(2)!.length - 1],
        text: line,
        blocks: [
          ...(res.group(1)!.isNotEmpty
              ? [ParsedBlock(type: BlockType.text, text: res.group(1)!)]
              : []),
          ParsedBlock(type: BlockType.symbol, text: res.group(2)!),
          ..._parseText(res.group(3)!),
        ],
      );
    } else {
      return null;
    }
  }

  ParsedLine? _isListItemLine(String line) {
    final reg = RegExp("( *-)( +.*)");
    final res = reg.firstMatch(line);
    if (res == null) {
      return null;
    } else if (res.start == 0 && res.end == line.length) {
      return ParsedLine(
        type: LineType.list,
        text: line,
        blocks: [
          ParsedBlock(
              type: BlockType.symbol,
              text: res.group(1)!.replaceFirst("-", "･")),
          ..._parseText(res.group(2)!),
        ],
      );
    } else {
      return null;
    }
  }

  ParsedLine? _isQuoteLine(String line) {
    final reg = RegExp("( *>)( +.*)");
    final res = reg.firstMatch(line);
    if (res == null) {
      return null;
    } else if (res.start == 0 && res.end == line.length) {
      return ParsedLine(
        type: LineType.quote,
        text: line,
        blocks: [
          ParsedBlock(type: BlockType.symbol, text: res.group(1)!),
          ..._parseText(res.group(2)!),
        ],
      );
    } else {
      return null;
    }
  }

  ParsedLine? _isInfoLine(String line) {
    final reg = RegExp("( *:::info)( +.*)");
    final res = reg.firstMatch(line);
    if (res == null) {
      return null;
    } else if (res.start == 0 && res.end == line.length) {
      return ParsedLine(
        type: LineType.info,
        text: line,
        blocks: [
          ParsedBlock(type: BlockType.symbol, text: res.group(1)!),
          ..._parseText(res.group(2)!),
        ],
      );
    } else {
      return null;
    }
  }

  List<ParsedBlock> _parseText(String text) {
    if (text.length <= 4) {
      return [
        ParsedBlock(type: BlockType.text, text: text),
      ];
    }

    final regItalic = RegExp(r"(__).+?__");
    final resItalic = regItalic.allMatches(text).toList();

    final regBold = RegExp(r"(\*\*).+?\*\*");
    final resBold = regBold.allMatches(text).toList();

    final regLink = RegExp(r"(http)s?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+");
    final resLink = regLink.allMatches(text);

    final reses = [
      ...resItalic,
      ...resBold,
      ...resLink,
    ];
    reses.sort((a, b) => a.start.compareTo(b.start));
    int passedLength = 0;
    List<ParsedBlock> blocks = [];
    for (final res in reses) {
      if (res.start == passedLength) {
        if (res.group(1)! == "__") {
          blocks.add(
            ParsedBlock(
              type: BlockType.italic,
              text: res.group(0)!,
            ),
          );
        } else if (res.group(1)! == "**") {
          blocks.add(
            ParsedBlock(
              type: BlockType.bold,
              text: res.group(0)!,
            ),
          );
        } else {
          blocks.add(
            ParsedBlock(
              type: BlockType.link,
              text: res.group(0)!,
            ),
          );
        }
        passedLength = res.end;
      } else if (res.start > passedLength) {
        blocks.addAll(
          _parseSubtext(text.substring(passedLength, res.start)),
        );
        if (res.group(1)! == "__") {
          blocks.add(
            ParsedBlock(
              type: BlockType.italic,
              text: res.group(0)!,
            ),
          );
        } else if (res.group(1)! == "**") {
          blocks.add(
            ParsedBlock(
              type: BlockType.bold,
              text: res.group(0)!,
            ),
          );
        } else {
          blocks.add(
            ParsedBlock(
              type: BlockType.link,
              text: res.group(0)!,
            ),
          );
        }
        passedLength = res.end;
      }
    }
    if (passedLength < text.length) {
      blocks.addAll(
        _parseSubtext(text.substring(passedLength)),
      );
    }
    return blocks;
  }

  List<ParsedBlock> _parseSubtext(String text) {
    if (text.length <= 4) {
      return [
        ParsedBlock(type: BlockType.text, text: text),
      ];
    }

    final regItalic = RegExp(r"(__).+?__");
    final resItalic = regItalic.allMatches(text).toList();

    final regBold = RegExp(r"(\*\*).+?\*\*");
    final resBold = regBold.allMatches(text).toList();

    final reses = [
      ...resItalic,
      ...resBold,
    ];
    reses.sort((a, b) => a.start.compareTo(b.start));
    int passedLength = 0;
    List<ParsedBlock> blocks = [];
    for (final res in reses) {
      if (res.start == passedLength) {
        if (res.group(1)! == "__") {
          blocks.add(
            ParsedBlock(
              type: BlockType.italic,
              text: res.group(0)!,
            ),
          );
        } else {
          blocks.add(
            ParsedBlock(
              type: BlockType.bold,
              text: res.group(0)!,
            ),
          );
        }
        passedLength = res.end;
      } else if (res.start > passedLength) {
        blocks.add(
          ParsedBlock(
            type: BlockType.text,
            text: text.substring(passedLength, res.start),
          ),
        );
        if (res.group(1)! == "__") {
          blocks.add(
            ParsedBlock(
              type: BlockType.italic,
              text: res.group(0)!,
            ),
          );
        } else {
          blocks.add(
            ParsedBlock(
              type: BlockType.bold,
              text: res.group(0)!,
            ),
          );
        }
        passedLength = res.end;
      }
    }
    if (passedLength < text.length) {
      blocks.add(
        ParsedBlock(
          type: BlockType.text,
          text: text.substring(passedLength),
        ),
      );
    }
    return blocks;
  }
}
