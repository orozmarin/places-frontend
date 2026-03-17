import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingSummaryCard extends StatefulWidget {
  const RatingSummaryCard({
    super.key,
    required this.rating,
    required this.onEditRating,
    required this.onDeleteRating,
  });

  final Function() onEditRating;
  final Function() onDeleteRating;
  final Rating rating;

  @override
  State<RatingSummaryCard> createState() => _RatingSummaryCardState();
}

class _RatingSummaryCardState extends State<RatingSummaryCard> {
  @override
  Widget build(BuildContext context) {
    final double total = (widget.rating.ambientRating ?? 0) +
        (widget.rating.priceRating ?? 0) +
        (widget.rating.foodRating ?? 0);
    final Color ringColor = total > 20
        ? const Color(0xFF4CAF50)
        : (total >= 12 ? const Color(0xFFFFC107) : Colors.red);

    return InkWell(
      onTap: () {
        widget.onEditRating();
        setState(() {});
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: _ScoreArcPainter(score: total, color: ringColor),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total % 1 == 0
                            ? total.toInt().toString()
                            : total.toStringAsFixed(1),
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/30',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildScoreRow('🎭', 'Experience', widget.rating.ambientRating ?? 0, ringColor),
            const SizedBox(height: 12),
            _buildScoreRow('🍽', 'Food', widget.rating.foodRating ?? 0, ringColor),
            const SizedBox(height: 12),
            _buildScoreRow('💰', 'Price', widget.rating.priceRating ?? 0, ringColor),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  widget.onDeleteRating();
                  setState(() {});
                },
                child: Text(
                  'Reset',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String emoji, String label, double value, Color barColor) {
    final displayValue =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(label, style: GoogleFonts.outfit(fontSize: 14)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$displayValue/10',
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _ScoreArcPainter extends CustomPainter {
  final double score;
  final Color color;

  _ScoreArcPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const startAngle = -pi * 0.75;
    const totalSweep = pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    final sweepAngle = totalSweep * (score / 30).clamp(0.0, 1.0);
    if (sweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ScoreArcPainter old) =>
      old.score != score || old.color != color;
}
