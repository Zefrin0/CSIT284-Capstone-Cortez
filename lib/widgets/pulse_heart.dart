import 'dart:math' as math;

import 'package:flutter/material.dart';

class PulseHeart extends StatefulWidget {
  const PulseHeart({super.key, this.size = 180});

  final double size;

  @override
  State<PulseHeart> createState() => _PulseHeartState();
}

class _PulseHeartState extends State<PulseHeart>
    with TickerProviderStateMixin {
  late final AnimationController _beatController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  late final Animation<double> _beat = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.22)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.22, end: 1.0)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.14)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.14, end: 1.0)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 12,
    ),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 52),
  ]).animate(_beatController);

  @override
  void dispose() {
    _beatController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Widget _ring(double phase, Color color) {
    final t = (_beatController.value + phase) % 1.0;
    final diameter = widget.size * (0.35 + 0.65 * t);
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: (1 - t) * 0.35),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final core = widget.size * 0.35;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_beatController, _floatController]),
        builder: (context, _) {
          final floatY =
              math.sin(_floatController.value * math.pi) * 14 - 7;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _ring(0.0, color),
                _ring(0.5, color),
                Transform.scale(
                  scale: _beat.value,
                  child: Container(
                    width: core,
                    height: core,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: core * 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}