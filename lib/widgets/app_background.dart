import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDFF1EA),
                  Color(0xFFF4F8F6),
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
        Positioned(top: -80, right: -60, child: _blob(primary, 240, 0.10)),
        Positioned(bottom: -100, left: -80, child: _blob(primary, 300, 0.08)),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _blob(Color color, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}