import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final int? quarterTurns;
  final Color? thumbColor;
  final Color? activeTrackColor;
  final int? divisions;

  const LevelSlider(
      {Key? key,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged,
      this.quarterTurns,
      this.thumbColor,
      this.activeTrackColor,
      this.divisions})
      : super(key: key);

  @override
  State<LevelSlider> createState() => _LevelSliderState();
}

class _LevelSliderState extends State<LevelSlider> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: widget.quarterTurns ?? -1,
      child: SliderTheme(
        data: SliderThemeData(
            valueIndicatorTextStyle: GoogleFonts.outfit(),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            thumbColor: widget.thumbColor ?? Theme.of(context).primaryColor,
            activeTrackColor: widget.activeTrackColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
            inactiveTrackColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 20),
            overlayShape: SliderComponentShape.noOverlay),
        child: GestureDetector(
          // Set the behavior to translucent to expand the touch area
          behavior: HitTestBehavior.translucent,
          child: Slider(
            min: widget.min,
            max: widget.max,
            value: widget.value,
            // thumbColor: Colors.white,
            divisions: widget.divisions ?? 10,
            // label: '${_verticalSliderValue.round()}',
            onChanged: (double value) {
              _triggerHapticFeedback(value);
              widget.onChanged(value);
            },
          ),
        ),
      ),
    );
  }

  void _triggerHapticFeedback(double newValue) {
    HapticFeedback.mediumImpact();
  }
}
