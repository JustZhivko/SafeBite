import 'package:flutter/material.dart';
import 'theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.bg0, AppTheme.bg1],
        ),
      ),
      child: Stack(
        children: [
          // Purple glow
          Positioned(
            top: -80,
            left: -40,
            child: _radial(AppTheme.accent.withOpacity(0.45)),
          ),

          // Blue glow
          Positioned(
            top: 120,
            right: -60,
            child: _radial(AppTheme.accent2.withOpacity(0.35)),
          ),

          // Cyan glow
          Positioned(
            bottom: -60,
            left: 20,
            child: _radial(AppTheme.accent3.withOpacity(0.18)),
          ),

          child,
        ],
      ),
    );
  }

  Widget _radial(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
