import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int steps, currentStep;

  final double dotSize;

  final double barHeight;
  final double borderRadius;
  final Color activeColor, inactiveColor;

  const StepProgressBar({
    super.key,
    required this.steps,
    required this.currentStep,
    this.dotSize = 20,
    this.barHeight = 8,
    this.borderRadius = 4,
    this.activeColor = const Color(0xFF7FA1FF),
    this.inactiveColor = const Color(0xFFD5E1FF),
  });

  Widget buildDot(bool active) {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: active ? activeColor : inactiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildBar(bool filled) {
    return Expanded(
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          color: filled ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(steps > 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < steps; i++) ...[
            buildDot(i <= currentStep),
            // после каждого кружка, кроме последнего, идёт «бар»
            if (i < steps - 1) buildBar(i < currentStep),
          ],
        ],
      ),
    );
  }
}
