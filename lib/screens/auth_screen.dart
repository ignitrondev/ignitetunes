import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/neon_glow_background.dart';

// ══════════════════════════════════════════════════════════════════════════════
// AUTH SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleAuth() => setState(() => _isLogin = !_isLogin);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return NeonGlowBackground(
      showBackgroundImage: false,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48.0 : 20.0,
            vertical: 32.0,
          ),
          child: Column(
            children: [
              _buildBrandHeader(),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _isLogin
                      ? _LoginForm(
                          key: const ValueKey('login'),
                          onToggle: _toggleAuth,
                        )
                      : _RegisterForm(
                          key: const ValueKey('register'),
                          onToggle: _toggleAuth,
                        ),
                ),
              ),
              const SizedBox(height: 32),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFddb7ff).withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Icon(Icons.music_note, color: Color(0xFFddb7ff), size: 32),
              Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.local_fire_department,
                  color: const Color(0xFFddb7ff),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "IgniteTunes",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Experience the rhythm of light.",
          style: GoogleFonts.geist(
            fontSize: 14,
            color: const Color(0xFFcfc2d6).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['Privacy', 'Terms', 'Support'].map((label) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PLAIN TEXT INPUT FIELD
// ══════════════════════════════════════════════════════════════════════════════
class _TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _TextField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0xFF988d9f),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.geist(fontSize: 15, color: Colors.white),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 10),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4d4354)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4d4354)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFddb7ff), width: 1.5),
            ),
          ),
          cursorColor: const Color(0xFFddb7ff),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PASSWORD INPUT FIELD — manages its own obscure toggle
// ══════════════════════════════════════════════════════════════════════════════
class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const _PasswordField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0xFF988d9f),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              // Key forces Flutter to destroy & recreate TextField when obscureText changes
              // This is the only reliable fix for the Symbol($signatureRti) bug on Flutter Web
              child: KeyedSubtree(
                key: ValueKey(_obscure),
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscure,
                  autofocus: false,
                  style: GoogleFonts.geist(fontSize: 15, color: Colors.white),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 10),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4d4354)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4d4354)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFddb7ff), width: 1.5),
                    ),
                  ),
                  cursorColor: const Color(0xFFddb7ff),
                ),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFcfc2d6),
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// GLASS CARD
// ══════════════════════════════════════════════════════════════════════════════
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PRIMARY BUTTON
// ══════════════════════════════════════════════════════════════════════════════
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFddb7ff),
          foregroundColor: const Color(0xFF490080),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.geist(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// OR DIVIDER
// ══════════════════════════════════════════════════════════════════════════════
class _OrDivider extends StatelessWidget {
  const _OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 1,
                color: const Color(0xFF4d4354).withOpacity(0.4))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR CONTINUE WITH",
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: const Color(0xFFcfc2d6).withOpacity(0.5),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
            child: Container(
                height: 1,
                color: const Color(0xFF4d4354).withOpacity(0.4))),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SOCIAL BUTTON
// ══════════════════════════════════════════════════════════════════════════════
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SocialButton({Key? key, required this.label, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOGGLE ROW
// ══════════════════════════════════════════════════════════════════════════════
class _ToggleRow extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;
  const _ToggleRow(
      {Key? key,
      required this.question,
      required this.action,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(question,
              style: GoogleFonts.geist(
                  fontSize: 13, color: const Color(0xFFcfc2d6))),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: GoogleFonts.geist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFddb7ff),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFddb7ff),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LOGIN FORM
// ══════════════════════════════════════════════════════════════════════════════
class _LoginForm extends StatefulWidget {
  final VoidCallback onToggle;
  const _LoginForm({Key? key, required this.onToggle}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Back",
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text("Please enter your details to continue.",
              style: GoogleFonts.geist(
                  fontSize: 14, color: const Color(0xFFcfc2d6))),
          const SizedBox(height: 32),

          _TextField(
            label: "Email Address",
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          _PasswordField(label: "Password", controller: _passCtrl),
          const SizedBox(height: 20),

          // Remember me + Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _remember = !_remember),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _remember
                              ? const Color(0xFFddb7ff)
                              : const Color(0xFF4d4354),
                        ),
                      ),
                      child: _remember
                          ? const Center(
                              child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFFddb7ff)))
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text("Remember me",
                        style: GoogleFonts.jetBrainsMono(
                            fontSize: 11, color: const Color(0xFFcfc2d6))),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text("Forgot Password?",
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 11, color: const Color(0xFFddb7ff))),
              ),
            ],
          ),
          const SizedBox(height: 28),

          _PrimaryButton(label: "Ignite Session", onPressed: () {}),
          const SizedBox(height: 24),

          const _OrDivider(),
          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(child: _SocialButton(label: "Google", icon: Icons.g_mobiledata)),
              SizedBox(width: 12),
              Expanded(child: _SocialButton(label: "Apple", icon: Icons.apple)),
            ],
          ),
          const SizedBox(height: 24),

          _ToggleRow(
            question: "Don't have an account?",
            action: "Create Account",
            onTap: widget.onToggle,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// REGISTER FORM
// ══════════════════════════════════════════════════════════════════════════════
class _RegisterForm extends StatefulWidget {
  final VoidCallback onToggle;
  const _RegisterForm({Key? key, required this.onToggle}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Join the Beat",
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text("Create your space in the neon soundscape.",
              style: GoogleFonts.geist(
                  fontSize: 14, color: const Color(0xFFcfc2d6))),
          const SizedBox(height: 32),

          _TextField(label: "Full Name", controller: _nameCtrl),
          const SizedBox(height: 24),

          _TextField(
            label: "Email Address",
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          _PasswordField(label: "Create Password", controller: _passCtrl),
          const SizedBox(height: 32),

          _PrimaryButton(label: "Join IgniteTunes", onPressed: () {}),
          const SizedBox(height: 24),

          _ToggleRow(
            question: "Already a member?",
            action: "Log In",
            onTap: widget.onToggle,
          ),
        ],
      ),
    );
  }
}
