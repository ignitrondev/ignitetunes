import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_card.dart';
import '../widgets/music_visualizer.dart';
import '../widgets/neon_glow_background.dart';
import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return NeonGlowBackground(
      showBackgroundImage: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48.0 : 20.0,
          vertical: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Branding
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFddb7ff),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFddb7ff).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFF490080),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "IgniteTunes",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Skip",
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color(0xFFcfc2d6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),

            // 2. Onboarding Centerpiece Card
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 560),
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GlassCard(
                          borderRadius: 32,
                          padding: EdgeInsets.all(isDesktop ? 40.0 : 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Staggered equalizer animation
                              const MusicVisualizer(),
                              const SizedBox(height: 24),

                              // Headline text
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: isDesktop ? 32 : 26,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  children: const [
                                    TextSpan(text: "Ignite Your Passion\n"),
                                    TextSpan(
                                      text: "for Music",
                                      style: TextStyle(color: Color(0xFFddb7ff)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description text
                              Text(
                                "Experience high-fidelity audio wrapped in an interface that breathes with the rhythm. Join the future of sound.",
                                style: GoogleFonts.geist(
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFcfc2d6),
                                ),
                              ),
                              const SizedBox(height: 36),

                              // CTA Button "Get Started"
                              MouseRegion(
                                onEnter: (_) => setState(() => _isHovered = true),
                                onExit: (_) => setState(() => _isHovered = false),
                                child: AnimatedScale(
                                  scale: _isHovered ? 1.04 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, _) =>
                                              const AuthScreen(),
                                          transitionsBuilder:
                                              (context, animation, _, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFddb7ff),
                                      foregroundColor: const Color(0xFF490080),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      elevation: 10,
                                      shadowColor: const Color(0xFFddb7ff).withOpacity(0.4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Get Started",
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Transparent music note graphic in top-right of the card
                        const Positioned(
                          top: -15,
                          right: -15,
                          child: Opacity(
                            opacity: 0.08,
                            child: Icon(
                              Icons.music_note,
                              size: 160,
                              color: Color(0xFFddb7ff),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Steps indicator & Active Listeners row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dots Indicator
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFddb7ff),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4d4354),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4d4354),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ],
                          ),
                          // Stacked Avatars
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: const Color(0xFF131313),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(999),
                                            child: Image.asset('assets/images/user1.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 14,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: const Color(0xFF131313),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(999),
                                            child: Image.asset('assets/images/user2.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 28,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: const Color(0xFF2a2a2a),
                                        child: Text(
                                          "+4k",
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 7.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Listening now",
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFcfc2d6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 2),

            // 4. Asymmetric Features Section (Bottom Grid)
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.high_quality,
                        color: const Color(0xFFddb7ff),
                        label: "Lossless Audio",
                      ),
                      const SizedBox(height: 16),
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: _buildFeatureCard(
                          icon: Icons.auto_awesome,
                          color: const Color(0xFFb76dff),
                          label: "Smart Playlists",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 12),
                        child: _buildFeatureCard(
                          icon: Icons.offline_pin,
                          color: const Color(0xFFadc6ff),
                          label: "Offline Sync",
                        ),
                      ),
                      const SizedBox(height: 16),
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: _buildFeatureCard(
                          icon: Icons.all_inclusive,
                          color: const Color(0xFF988d9f),
                          label: "Cross-Device",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
