import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isBackgroundLoaded = false;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  // Page 1 animations
  late AnimationController _animationController;
  late Animation<double> _profile1Animation;
  late Animation<double> _profile2Animation;
  late Animation<double> _profile3Animation;

  // Page 2 animations
  late AnimationController _snakeAnimationController;
  late Animation<double> _snakeAnimation;
  late AnimationController _cylinderAnimationController;
  late Animation<double> _cylinder1Animation;
  late Animation<double> _cylinder2Animation;
  late Animation<double> _cylinder3Animation;

  // Page 3 animations
  late AnimationController _ringAnimationController;
  late Animation<double> _ring1Animation;
  late Animation<double> _ring2Animation;
  late Animation<double> _ring3Animation;
  late Animation<double> _ring4Animation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _preloadBackground();
    _startAnimations();
  }

  Future<void> _preloadBackground() async {
    try {
      // Preload the background image
      await precacheImage(
        const AssetImage('assets/pngs/subcription_bg.png'),
        context,
      );
      if (mounted) {
        setState(() {
          _isBackgroundLoaded = true;
        });
        _backgroundAnimationController.forward();
      }
    } catch (e) {
      // If image fails to load, still set as loaded to show fallback
      if (mounted) {
        setState(() {
          _isBackgroundLoaded = true;
        });
        _backgroundAnimationController.forward();
      }
    }
  }

  void _setupAnimations() {
    // Background animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Page 1 animations
    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: 3000), // Increased from 1800ms for slower animation
      vsync: this,
    );
    _profile1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.1, 0.4,
          curve: Curves
              .easeOutCubic), // Changed from elasticOut for smoother animation
    ));

    _profile2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.7,
          curve: Curves
              .easeOutCubic), // Changed from elasticOut for smoother animation
    ));

    _profile3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0,
          curve: Curves
              .easeOutCubic), // Changed from elasticOut for smoother animation
    ));

    // Page 2 animations
    _snakeAnimationController = AnimationController(
      duration: Duration(seconds: 3), // 3 seconds to complete the flow
      vsync: this,
    );

    _snakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _snakeAnimationController,
      curve: Curves.easeInOut,
    ));
    _cylinderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Listen to page changes
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;

      // Start animation ONLY once when reaching page 2 (index 1)
      if (page >= 1.0 && page < 2.0) {
        if (_snakeAnimationController.status == AnimationStatus.dismissed) {
          _snakeAnimationController
              .forward(); // Only start if not already started
        }
      } else if (page < 1.0) {
        _snakeAnimationController
            .reset(); // Reset only when going back to page 1
      }
      // Don't reset when going to page 3 - let it stay completed

      // Start ring animations when reaching page 3 (index 2)
      if (page >= 2.0 && page < 3.0) {
        if (_ringAnimationController.status == AnimationStatus.dismissed) {
          _ringAnimationController.forward();
        }
      } else if (page < 2.0) {
        _ringAnimationController.reset();
      }
    });

    _snakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _snakeAnimationController,
      curve: Curves.easeInOut,
    ));

    _cylinder1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cylinderAnimationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    _cylinder2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cylinderAnimationController,
      curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
    ));

    _cylinder3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cylinderAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
    ));

    // Waterflow animation - smooth and non-repeating
    _snakeAnimationController.forward();

    // Page 3 ring animations - faster fade-in with overlapping timing
    _ringAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: 1200), // Reduced from 3000ms to 1200ms
      vsync: this,
    );

    _ring1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ringAnimationController,
      curve: const Interval(0.0, 0.4,
          curve: Curves
              .easeInOut), // Changed from elasticOut to easeInOut for smoother fade
    ));

    _ring2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ringAnimationController,
      curve: const Interval(0.1, 0.5,
          curve: Curves.easeInOut), // Starts earlier, overlaps with ring1
    ));

    _ring3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ringAnimationController,
      curve: const Interval(0.2, 0.6,
          curve: Curves.easeInOut), // Starts even earlier, more overlap
    ));

    _ring4Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ringAnimationController,
      curve: const Interval(0.3, 0.7,
          curve:
              Curves.easeInOut), // Starts earlier, overlaps with previous rings
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _currentPage == 0) {
        _animationController.forward();
      }
    });
  }

  void _startPage2Animations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _cylinderAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _animationController.dispose();
    _snakeAnimationController.dispose();
    _cylinderAnimationController.dispose();
    _ringAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    try {
   
      await SecureStorage.write('has_launched_before', 'true');

      NavigationService navigationService = NavigationService();

      if (LoggedIn) {
        navigationService.pushNamedReplacement('MainPage');
      } else {
        navigationService.pushNamedReplacement('PhoneNumber');
      }
    } catch (e) {
      print('Error completing onboarding: $e');
      NavigationService().pushNamedReplacement('PhoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1D09CD), 
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1D09CD),
                  const Color.fromARGB(255, 33, 16, 73),
                  const Color.fromARGB(255, 14, 11, 78),
                ],
              ),
              image: _isBackgroundLoaded
                  ? DecorationImage(
                      image: const AssetImage('assets/pngs/subcription_bg.png'),
                      fit: BoxFit.cover,
                      opacity: _backgroundAnimation.value * 0.9,
                    )
                  : null,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: _isBackgroundLoaded
                        ? PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                              if (index == 1) {
                                _cylinderAnimationController.reset();
                                _startPage2Animations();
                              }
                            },
                            children: [
                              _buildPage1(),
                              _buildPage2(),
                              _buildPage3(),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),

                        // Next button
                        GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2B5CE6),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(       'assets/splash_assets/next_button.svg')
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
            if (index == 1) {
              _startPage2Animations();
            }
          },

        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Top area for profile images
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55, // upper part
            child: Stack(
              children: [
                // Top profile
                Positioned(
                  top: 40,
                  left: 40,
                  child: AnimatedBuilder(
                    animation: _profile1Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile1Animation.value,
                        child: Opacity(
                          opacity: _profile1Animation.value.clamp(0.0, 1.0),
                          child: _buildProfileCard(
                            'assets/splash_assets/profile2.png',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Right profile
                Positioned(
                  top: 180,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _profile2Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile2Animation.value,
                        child: Opacity(
                          opacity: _profile2Animation.value.clamp(0.0, 1.0),
                          child: _buildProfileCard(
                            'assets/splash_assets/profile1.png',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom-left profile
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: AnimatedBuilder(
                    animation: _profile3Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile3Animation.value,
                        child: Opacity(
                          opacity: _profile3Animation.value.clamp(0.0, 1.0),
                          child: _buildProfileCard(
                            'assets/splash_assets/profile3.png',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Spacer between profiles and text
          const SizedBox(height: 40),

          // Bottom text content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expand Your Network',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Text(
                'Discover professionals, list your business & products, and search job profiles.',
                style: TextStyle(
                  fontSize: 14,
                  color: kSecondaryTextColor,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _snakeAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 500),
                      painter: LiquidSnakePainter(_snakeAnimation.value),
                    );
                  },
                ),
                Positioned(
                  top: 100,
                  left: 100,
                  child: AnimatedBuilder(
                    animation: _cylinder1Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder1Animation.value,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Opacity(
                            opacity: _cylinder1Animation.value.clamp(0.0, 1.0),
                            child: _buildCylinderCard(
                              'assets/splash_assets/cylinder_1.png',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 120,
                  child: AnimatedBuilder(
                    animation: _cylinder2Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder2Animation.value,
                        child: Transform.rotate(
                          angle: -0.12, 
                          child: Opacity(
                            opacity: _cylinder2Animation.value.clamp(0.0, 1.0),
                            child: _buildCylinderCard(
                              'assets/splash_assets/cylinder_2.png',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 140,
                  child: AnimatedBuilder(
                    animation: _cylinder3Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder3Animation.value,
                        child: Transform.rotate(
                          angle: -0.18, 
                          child: Opacity(
                            opacity: _cylinder3Animation.value.clamp(0.0, 1.0),
                            child: _buildCylinderCard(
                              'assets/splash_assets/cylinder_3.png',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect & Collaborate',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Text(
                'Join business communities, collaborate with professionals, and grow your network.',
                style: TextStyle(
                  fontSize: 14,
                  color: kSecondaryTextColor,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -120,
                  right: -240,
                  child: AnimatedBuilder(
                    animation: _ring4Animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: 0.2,
                        child: Opacity(
                          opacity: _ring4Animation.value.clamp(0.0, 1.0),
                          child: Image.asset(
                            'assets/splash_assets/ring_4.png',
                            width: 440,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: AnimatedBuilder(
                    animation: _ring3Animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: -0.1,
                        child: Opacity(
                          opacity: _ring3Animation.value.clamp(0.0, 1.0),
                          child: Image.asset(
                            'assets/splash_assets/ring_3.png',
                            width: 300,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  left: -20,
                  child: AnimatedBuilder(
                    animation: _ring2Animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: 0.05,
                        child: Opacity(
                          opacity: _ring2Animation.value.clamp(0.0, 1.0),
                          child: Image.asset(
                            'assets/splash_assets/ring_2.png',
                            width: 310,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 20,
                  left: -30,
                  child: AnimatedBuilder(
                    animation: _ring1Animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: -0.15,
                        child: Opacity(
                          opacity: _ring1Animation.value.clamp(0.0, 1.0),
                          child: Image.asset(
                            'assets/splash_assets/ring_1.png',
                            width: 180,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Digital Power',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Text(
                'Access your digital IPA Connect Card, share promotions, IPA stores and enjoy member-only offers and news.',
                style: TextStyle(
                  fontSize: 14,
                  color: kSecondaryTextColor,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String imagePath) {
    return Container(
      width: 130,
      height: 130,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCylinderCard(
    String imagePath,
  ) {
    return SizedBox(
      width: 171,
      height: 170,
      child: Image.asset(
        imagePath,
      ),
    );
  }
}

class LiquidSnakeWidget extends StatefulWidget {
  @override
  _LiquidSnakeWidgetState createState() => _LiquidSnakeWidgetState();
}

class _LiquidSnakeWidgetState extends State<LiquidSnakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: LiquidSnakePainter(_animation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class LiquidSnakePainter extends CustomPainter {
  final double animationValue;

  LiquidSnakePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue <= 0) return;

    final width = size.width;
    final height = size.height;

    final path = Path();

    final startX = -width * 0.2;
    final startY = height * 0.4;
    path.moveTo(startX, startY);
    path.cubicTo(
      width * 0.1, height * 0.1, 
      width * 0.4, height * 0.1, 
      width * 0.3, height * 0.45,
    );
    path.cubicTo(
      width * 0.2, height * 0.7, 
      width * 0.05, height * 0.6,
      width * 0.15, height * 0.4,
    );

    path.cubicTo(
      width * 0.35,
      height * 0.1,
      width * 0.65,
      height * 0.2,
      width * 0.6,
      height * 0.5,
    );
    path.cubicTo(
      width * 0.55,
      height * 0.75,
      width * 0.35,
      height * 0.7,
      width * 0.5,
      height * 0.4,
    );
    path.cubicTo(
      width * 0.8,
      height * 0.2,
      width * 1.1,
      height * 0.5,
      width * 1.2,
      height * 0.6,
    );

    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final totalLength = pathMetric.length;
    final currentLength = totalLength * animationValue;

    final extractedPath = pathMetric.extractPath(0, currentLength);

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1D09CD),
          const Color(0xFFB9B5FF),
        ],
      ).createShader(Rect.fromLTWH(startX, 0, width * 1.4, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = height * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(extractedPath, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
