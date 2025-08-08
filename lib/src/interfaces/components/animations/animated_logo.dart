import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class AnimatedSvgLogo extends StatefulWidget {
  final String assetPath;
  final double size;
  final Duration animationDuration;
  final bool enableRotation;
  final bool enablePulse;
  final bool enableFade;
  final bool enableScale;
  final bool enableFloat;
  final Color? colorFilter;
  final BoxFit fit;

  const AnimatedSvgLogo({
    Key? key,
    required this.assetPath,
    this.size = 100.0,
    this.animationDuration = const Duration(seconds: 3),
    this.enableRotation = false,
    this.enablePulse = true,
    this.enableFade = true,
    this.enableScale = false,
    this.enableFloat = true,
    this.colorFilter,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<AnimatedSvgLogo> createState() => _AnimatedSvgLogoState();
}

class _AnimatedSvgLogoState extends State<AnimatedSvgLogo>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _floatController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Rotation Animation
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // Full rotation in radians
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Pulse Animation (subtle breathing effect)
    _pulseController = AnimationController(
      duration: Duration(
          milliseconds:
              (widget.animationDuration.inMilliseconds * 0.6).round()),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Fade Animation (opacity breathing)
    _fadeController = AnimationController(
      duration: Duration(
          milliseconds:
              (widget.animationDuration.inMilliseconds * 0.8).round()),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Scale Animation (growth effect)
    _scaleController = AnimationController(
      duration: Duration(
          milliseconds:
              (widget.animationDuration.inMilliseconds * 1.2).round()),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticInOut,
    ));

    // Float Animation (vertical movement)
    _floatController = AnimationController(
      duration: Duration(
          milliseconds:
              (widget.animationDuration.inMilliseconds * 0.7).round()),
      vsync: this,
    );
    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    if (widget.enableRotation) {
      _rotationController.repeat();
    }

    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }

    if (widget.enableFade) {
      _fadeController.repeat(reverse: true);
    }

    if (widget.enableScale) {
      _scaleController.repeat(reverse: true);
    }

    if (widget.enableFloat) {
      _floatController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationController,
        _pulseController,
        _fadeController,
        _scaleController,
        _floatController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.enableFloat ? _floatAnimation.value : 0),
          child: Transform.rotate(
            angle: widget.enableRotation ? _rotationAnimation.value : 0,
            child: Transform.scale(
              scale: _getCombinedScale(),
              child: Opacity(
                opacity: widget.enableFade ? _fadeAnimation.value : 1.0,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: SvgPicture.asset(
                    widget.assetPath,
                    width: widget.size,
                    height: widget.size,
                    fit: widget.fit,
                    colorFilter: widget.colorFilter != null
                        ? ColorFilter.mode(widget.colorFilter!, BlendMode.srcIn)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getCombinedScale() {
    double scale = 1.0;

    if (widget.enablePulse) {
      scale *= _pulseAnimation.value;
    }

    if (widget.enableScale) {
      scale *= _scaleAnimation.value;
    }

    return scale;
  }
}

class AnimatedSvgLogoPresets {
  static Widget subtle({
    required String assetPath,
    double size = 120.0,
    Color? colorFilter,
  }) {
    return AnimatedSvgLogo(
      assetPath: assetPath,
      size: size,
      animationDuration: const Duration(seconds: 4),
      enableRotation: false,
      enablePulse: true,
      enableFade: true,
      enableScale: false,
      enableFloat: false,
      colorFilter: colorFilter,
    );
  }

  static Widget floating({
    required String assetPath,
    double size = 120.0,
    Color? colorFilter,
  }) {
    return AnimatedSvgLogo(
      assetPath: assetPath,
      size: size,
      animationDuration: const Duration(seconds: 3),
      enableRotation: false,
      enablePulse: true,
      enableFade: false,
      enableScale: false,
      enableFloat: true,
      colorFilter: colorFilter,
    );
  }

  // Rotating logo
  static Widget rotating({
    required String assetPath,
    double size = 120.0,
    Color? colorFilter,
  }) {
    return AnimatedSvgLogo(
      assetPath: assetPath,
      size: size,
      animationDuration: const Duration(seconds: 8),
      enableRotation: true,
      enablePulse: false,
      enableFade: false,
      enableScale: false,
      enableFloat: false,
      colorFilter: colorFilter,
    );
  }

  // Dynamic with multiple effects
  static Widget dynamic({
    required String assetPath,
    double size = 120.0,
    Color? colorFilter,
  }) {
    return AnimatedSvgLogo(
      assetPath: assetPath,
      size: size,
      animationDuration: const Duration(seconds: 5),
      enableRotation: false,
      enablePulse: true,
      enableFade: true,
      enableScale: true,
      enableFloat: true,
      colorFilter: colorFilter,
    );
  }

  // Minimal breathing effect
  static Widget breathing({
    required String assetPath,
    double size = 120.0,
    Color? colorFilter,
  }) {
    return AnimatedSvgLogo(
      assetPath: assetPath,
      size: size,
      animationDuration: const Duration(seconds: 2),
      enableRotation: false,
      enablePulse: true,
      enableFade: false,
      enableScale: false,
      enableFloat: false,
      colorFilter: colorFilter,
    );
  }
}

// Usage Example Widget
class SvgLogoShowcase extends StatelessWidget {
  const SvgLogoShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Animated SVG Logo Showcase'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Your Original Logo with Subtle Animation
            const Text(
              'Your Logo - Subtle Animation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSvgLogoPresets.subtle(
              assetPath: 'assets/svg/ipa_login_logo.svg',
              size: 150,
            ),

            const SizedBox(height: 40),

            // Floating Effect
            const Text(
              'Floating Effect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSvgLogoPresets.floating(
              assetPath: 'assets/svg/ipa_login_logo.svg',
              size: 140,
            ),

            const SizedBox(height: 40),

            // Custom Configuration
            const Text(
              'Custom Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSvgLogo(
              assetPath: 'assets/svg/ipa_login_logo.svg',
              size: 160,
              animationDuration: const Duration(seconds: 3),
              enableRotation: false,
              enablePulse: true,
              enableFade: true,
              enableScale: false,
              enableFloat: true,
              colorFilter: Colors.blue.shade300,
            ),

            const SizedBox(height: 40),

            // Breathing Effect
            const Text(
              'Breathing Effect Only',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSvgLogoPresets.breathing(
              assetPath: 'assets/svg/ipa_login_logo.svg',
              size: 130,
            ),
          ],
        ),
      ),
    );
  }
}
