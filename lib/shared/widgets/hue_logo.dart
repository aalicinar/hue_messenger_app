import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum HueLogoTone { balanced, vivid }

class HueLogo extends StatelessWidget {
  const HueLogo({
    super.key,
    this.size = 44,
    this.enableAnimation = false,
    this.showShadow = true,
    this.tone = HueLogoTone.vivid,
  });

  final double size;
  final bool enableAnimation;
  final bool showShadow;
  final HueLogoTone tone;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.28);
    final logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.28),
                  blurRadius: size * 0.24,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CustomPaint(painter: _SimpleHueLogoPainter(tone: tone)),
      ),
    );

    if (!enableAnimation) return logo;

    return logo
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(0.988, 0.988),
          end: const Offset(1, 1),
          duration: 1200.ms,
          curve: Curves.easeInOut,
        );
  }
}

class _SimpleHueLogoPainter extends CustomPainter {
  const _SimpleHueLogoPainter({required this.tone});

  final HueLogoTone tone;

  static const _laneColors = <Color>[
    Color(0xFF007AFF), // blue (iOS)
    Color(0xFF34C759), // green (iOS)
    Color(0xFFFFB800), // yellow (iOS)
    Color(0xFFFF3B30), // red (iOS)
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final vivid = tone == HueLogoTone.vivid;

    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0A1020), Color(0xFF14213D)],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    if (vivid) {
      final tintPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x18007AFF),
            Color(0x1434C759),
            Color(0x14FFB800),
            Color(0x1AFF3B30),
          ],
        ).createShader(rect);
      canvas.drawRect(rect, tintPaint);
    }

    _drawSpeedLanes(canvas, size, vivid);
    _drawBubble(canvas, size, vivid);
  }

  void _drawSpeedLanes(Canvas canvas, Size size, bool vivid) {
    final stroke = size.width * (vivid ? 0.1 : 0.082);
    final yStart = size.height * 0.24;
    final step = size.height * 0.16;

    for (var i = 0; i < _laneColors.length; i++) {
      final y = yStart + (step * i);
      final laneRect = Rect.fromLTRB(
        size.width * 0.08,
        y - (stroke * 0.42),
        size.width * 0.44,
        y + (stroke * 0.42),
      );
      final lane = RRect.fromRectAndRadius(laneRect, Radius.circular(stroke));
      final lanePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            _laneColors[i].withValues(alpha: vivid ? 0.98 : 0.9),
            _laneColors[i].withValues(alpha: vivid ? 0.62 : 0.42),
          ],
        ).createShader(laneRect);
      canvas.drawRRect(lane, lanePaint);
    }
  }

  void _drawBubble(Canvas canvas, Size size, bool vivid) {
    final bubbleRect = Rect.fromCenter(
      center: Offset(size.width * 0.64, size.height * 0.49),
      width: size.width * 0.54,
      height: size.height * 0.43,
    );
    final bubble = RRect.fromRectAndRadius(
      bubbleRect,
      Radius.circular(size.width * 0.12),
    );

    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: vivid ? 0.97 : 0.92);
    canvas.drawRRect(bubble, bubblePaint);

    final bubbleStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.024
      ..color = Colors.white.withValues(alpha: 0.74);
    canvas.drawRRect(bubble, bubbleStroke);

    final tailPath = Path()
      ..moveTo(
        bubbleRect.right - (size.width * 0.1),
        bubbleRect.bottom - (size.width * 0.014),
      )
      ..lineTo(
        bubbleRect.right + (size.width * 0.09),
        bubbleRect.bottom + (size.width * 0.09),
      )
      ..lineTo(
        bubbleRect.right + (size.width * 0.012),
        bubbleRect.bottom - (size.width * 0.11),
      )
      ..close();
    canvas.drawPath(tailPath, bubblePaint);
    canvas.drawPath(tailPath, bubbleStroke);

    _drawH(canvas, bubbleRect);
  }

  void _drawH(Canvas canvas, Rect bubbleRect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'H',
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: bubbleRect.height * 0.62,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      bubbleRect.center.dx - (textPainter.width / 2),
      bubbleRect.center.dy -
          (textPainter.height / 2) -
          (bubbleRect.height * 0.01),
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
