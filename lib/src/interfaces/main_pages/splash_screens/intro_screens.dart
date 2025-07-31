import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  
  // Page 1 animations
  late AnimationController _animationController;
  late Animation<double> _profile1Animation;
  late Animation<double> _profile2Animation;
  late Animation<double> _profile3Animation;
  
  // Page 2 animations
  late AnimationController _snakeAnimationController;
  late AnimationController _cylinderAnimationController;
  late Animation<double> _snakeAnimation;
  late Animation<double> _cylinder1Animation;
  late Animation<double> _cylinder2Animation;
  late Animation<double> _cylinder3Animation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Page 1 animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _profile1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    _profile2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
    ));

    _profile3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
    ));

    // Page 2 animations
    _snakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _cylinderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

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

    // Make snake animation repeat
    _snakeAnimationController.repeat();
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
    _animationController.dispose();
    _snakeAnimationController.dispose();
    _cylinderAnimationController.dispose();
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
      // Onboarding completed - mark app as launched and navigate
      await _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      // Mark the app as launched
      await SecureStorage.write('has_launched_before', 'true');
      
      // Navigate to appropriate screen based on login status
      NavigationService navigationService = NavigationService();
      
      if (LoggedIn) {
        // User is logged in, go to main page
        navigationService.pushNamedReplacement('MainPage');
      } else {
        // User is not logged in, go to phone number screen
        navigationService.pushNamedReplacement('PhoneNumber');
      }
    } catch (e) {
      print('Error completing onboarding: $e');
      // Fallback navigation
      NavigationService().pushNamedReplacement('PhoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/subcription_bg.png'), // Replace with your background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar spacing
              const SizedBox(height: 20),
              
              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    
                    // Start page 2 animations when reaching page 2
                    if (index == 1) {
                      _cylinderAnimationController.reset();
                      _startPage2Animations();
                    }
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),                  
                    _buildPlaceholderPage('title','description'),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const WormEffect(
                        dotColor: Colors.white24,
                        activeDotColor: Colors.white,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                      ),
                    ),
                    
                    // Next/Get Started button
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: _currentPage == 2 ? 120 : 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B5CE6),
                          shape: _currentPage == 2 ? BoxShape.rectangle : BoxShape.circle,
                          borderRadius: _currentPage == 2 ? BorderRadius.circular(28) : null,
                        ),
                        child: _currentPage == 2
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              )
                            : const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Profile images section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Top profile (bearded man with message bubble)
                Positioned(
                  top: 80,
                  left: 40,
                  child: AnimatedBuilder(
                    animation: _profile1Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile1Animation.value,
                        child: Opacity(
                          opacity: _profile1Animation.value,
                          child: _buildProfileCard(
                                'assets/svg/splash_assets/profile1.svg',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom right profile (man in suit with message bubble)
                Positioned(
                  top: 240,
                  right: 40,
                  child: AnimatedBuilder(
                    animation: _profile2Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile2Animation.value,
                        child: Opacity(
                          opacity: _profile2Animation.value,
                          child: _buildProfileCard(
                         'assets/svg/splash_assets/profile2.svg',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom left profile (woman in yellow with message bubble)
                Positioned(
                  top: 400,
                  left: 20,
                  child: AnimatedBuilder(
                    animation: _profile3Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profile3Animation.value,
                        child: Opacity(
                          opacity: _profile3Animation.value,
                          child: _buildProfileCard(
                              'assets/svg/splash_assets/profile3.svg',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Text content
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Expand Your Network',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Discover professionals, list your business & products, and search job profiles.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
          // Snake gradient and cylinders section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Animated snake gradient background
                AnimatedBuilder(
                  animation: _snakeAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 500),
                      painter: SnakePainter(_snakeAnimation.value),
                    );
                  },
                ),
                
                // Cylinder card 1 - "ICA Business Pulse"
                Positioned(
                  top: 100,
                  right: 40,
                  child: AnimatedBuilder(
                    animation: _cylinder1Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder1Animation.value,
                        child: Opacity(
                          opacity: _cylinder1Animation.value,
                          child: _buildCylinderCard(
                            'assets/images/cylinder_card_1.png', // ICA Business Pulse
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Cylinder card 2 - "BizSphere 2025"
                Positioned(
                  top: 200,
                  left: 60,
                  child: AnimatedBuilder(
                    animation: _cylinder2Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder2Animation.value,
                        child: Opacity(
                          opacity: _cylinder2Animation.value,
                          child: _buildCylinderCard(
                            'assets/images/cylinder_card_2.png', // BizSphere 2025
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Cylinder card 3 - "Swathi Ibrahim" with profile
                Positioned(
                  top: 320,
                  right: 20,
                  child: AnimatedBuilder(
                    animation: _cylinder3Animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cylinder3Animation.value,
                        child: Opacity(
                          opacity: _cylinder3Animation.value,
                          child: _buildCylinderCard(
                            'assets/images/cylinder_card_3.png', // Swathi Ibrahim
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Text content for page 2
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Connect & Collaborate',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Join business communities, collaborate with professionals, and grow your network.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String imagePath) {
    return Container(
      width: 150,
      height: 180,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCylinderCard(String imagePath) {
    return Container(
      width: 180,
      height: 60,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final double animationValue;
  
  SnakePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1D09CD),
          Color(0xFF6B46C1),
          Color(0xFFB9B5FF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Create snake-like path with animation
    final animOffset = animationValue * 50;
    
    // Start point
    path.moveTo(width * 0.1, height * 0.2 + sin(animationValue * 2 * pi) * 20);
    
    // First curve (top curve)
    path.quadraticBezierTo(
      width * 0.3 + cos(animationValue * 2 * pi) * 30, 
      height * 0.1 + sin(animationValue * 2 * pi + 1) * 15,
      width * 0.6, 
      height * 0.25 + cos(animationValue * 2 * pi + 0.5) * 25
    );
    
    // Second curve (middle curve)
    path.quadraticBezierTo(
      width * 0.8 + sin(animationValue * 2 * pi + 2) * 20, 
      height * 0.4 + cos(animationValue * 2 * pi + 1.5) * 30,
      width * 0.5 - cos(animationValue * 2 * pi) * 40, 
      height * 0.6 + sin(animationValue * 2 * pi + 2.5) * 25
    );
    
    // Third curve (bottom curve)
    path.quadraticBezierTo(
      width * 0.2 + sin(animationValue * 2 * pi + 3) * 35, 
      height * 0.75 + cos(animationValue * 2 * pi + 2) * 20,
      width * 0.7, 
      height * 0.85 + sin(animationValue * 2 * pi + 3.5) * 15
    );
    
    // Create thick stroke for snake body
    final strokePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFB9B5FF).withOpacity(0.8),
          Color(0xFF6B46C1).withOpacity(0.6),
          Color(0xFF1D09CD).withOpacity(0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 80 + sin(animationValue * 4 * pi) * 10
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(path, strokePaint);
    
    // Add glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFB9B5FF).withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 120
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(SnakePainter oldDelegate) => oldDelegate.animationValue != animationValue;

  Widget _buildGetStartedPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.rocket_launch,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Ready to Get Started?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of professionals and start building your network today!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.image,
              size: 80,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
  Widget _buildPlaceholderPage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.image,
              size: 80,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
