import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/neon_glow_background.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  String _loadingText = "Igniting audio engine...";
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  Timer? _progressTimer;

  final List<String> _steps = [
    "Igniting audio engine...",
    "Syncing library...",
    "Buffering neon waves...",
    "Finalizing experience...",
  ];

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _startLoadingJourney();
  }

  void _startLoadingJourney() {
    Future.delayed(const Duration(milliseconds: 800), () {
      _progressTimer =
          Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (!mounted) return;
        setState(() {
          _progress += (Random().nextInt(3) + 1) / 100.0;
          if (_progress >= 1.0) {
            _progress = 1.0;
            _progressTimer?.cancel();
            _onLoadingComplete();
          }
          if (_progress <= 0.25) {
            _loadingText = _steps[0];
          } else if (_progress <= 0.50) {
            _loadingText = _steps[1];
          } else if (_progress <= 0.85) {
            _loadingText = _steps[2];
          } else {
            _loadingText = _steps[3];
          }
        });
      });
    });
  }

  void _onLoadingComplete() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonGlowBackground(
      showBackgroundImage: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Floating Glass Logo
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _logoAnimation.value),
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.white.withValues(alpha: 0.04),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: const SizedBox(
                            width: 190,
                            height: 190,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Text(
                "IgniteTunes",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "FEEL THE HEAT OF HIGH-FIDELITY",
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3.0,
                  color: const Color(0xFFddb7ff),
                ),
              ),

              const Spacer(flex: 2),

              // Progress bar
              SizedBox(
                width: 280,
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progress,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFddb7ff),
                                    Color(0xFF842bd2),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFddb7ff)
                                        .withValues(alpha: 0.6),
                                    blurRadius:
                                        _progress >= 1.0 ? 15.0 : 8.0,
                                    spreadRadius:
                                        _progress >= 1.0 ? 2.0 : 0.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _loadingText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: const Color(0xFFcfc2d6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "${(_progress * 100).toInt()}%",
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: const Color(0xFFddb7ff),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              Text(
                "Powered by IgniteEngine v2.0",
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
