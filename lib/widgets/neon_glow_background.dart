import 'dart:ui';
import 'package:flutter/material.dart';

class NeonGlowBackground extends StatelessWidget {
  final Widget child;
  final bool showBackgroundImage;

  const NeonGlowBackground({
    super.key,
    required this.child,
    this.showBackgroundImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        children: [
          // 1. Ambient Glow 1 (Top-Right Purple/Violet)
          Positioned(
            top: -size.height * 0.1,
            right: -size.width * 0.1,
            width: size.width * 0.7,
            height: size.width * 0.7,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFddb7ff).withValues(alpha: 0.12),
                ),
              ),
            ),
          ),

          // 2. Ambient Glow 2 (Bottom-Left Blue/Azure)
          Positioned(
            bottom: -size.height * 0.1,
            left: -size.width * 0.1,
            width: size.width * 0.6,
            height: size.width * 0.6,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFadc6ff).withValues(alpha: 0.08),
                ),
              ),
            ),
          ),

          // 3. Concert Vibe Background Image (Luminosity mix-blend style)
          if (showBackgroundImage)
            Positioned.fill(
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  'assets/images/concert_bg.jpg',
                  fit: BoxFit.cover,
                  color: Colors.grey,
                  colorBlendMode: BlendMode.luminosity,
                ),
              ),
            ),

          // 4. Subtle center radial overlay for vignette effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // 5. Main Content Canvas
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
