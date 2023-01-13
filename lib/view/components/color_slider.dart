import 'package:flutter/material.dart';

class ColorSlider extends StatefulWidget {
  const ColorSlider({super.key, required this.initialColor, this.onChanged});

  final Color initialColor;
  final ValueChanged<Color>? onChanged;

  @override
  ColorSliderState createState() => ColorSliderState();
}

class ColorSliderState extends State<ColorSlider> {
  int r = 0;
  int g = 0;
  int b = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      r = widget.initialColor.red;
      g = widget.initialColor.green;
      b = widget.initialColor.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Color.fromARGB(255, r, g, b),
          child: const SizedBox(
            width: 50,
            height: 50,
          ),
        ),
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.red,
                activeTrackColor: Colors.red,
                activeTickMarkColor: null,
                inactiveTrackColor: Colors.white54,
                inactiveTickMarkColor: null,
                overlayColor: Colors.red.withAlpha(80),
              ),
              child: Slider(
                value: r.toDouble(),
                onChanged: (value) {
                  setState(() {
                    r = value.toInt();
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Color.fromARGB(255, r, g, b));
                  }
                },
                min: 0,
                max: 255,
                divisions: 255,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.green,
                activeTrackColor: Colors.green,
                activeTickMarkColor: null,
                inactiveTrackColor: Colors.white54,
                inactiveTickMarkColor: null,
                overlayColor: Colors.green.withAlpha(80),
              ),
              child: Slider(
                value: g.toDouble(),
                onChanged: (value) {
                  setState(() {
                    g = value.toInt();
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Color.fromARGB(255, r, g, b));
                  }
                },
                min: 0,
                max: 255,
                divisions: 255,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.blue,
                activeTrackColor: Colors.blue,
                activeTickMarkColor: null,
                inactiveTrackColor: Colors.white54,
                inactiveTickMarkColor: null,
                overlayColor: Colors.blue.withAlpha(80),
              ),
              child: Slider(
                value: b.toDouble(),
                onChanged: (value) {
                  setState(() {
                    b = value.toInt();
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Color.fromARGB(255, r, g, b));
                  }
                },
                min: 0,
                max: 255,
                divisions: 255,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
