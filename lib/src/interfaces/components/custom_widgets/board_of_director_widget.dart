import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class BoardDirector {
  final String name;
  final String title;
  final String company;
  final String imageUrl;
  final Color backgroundColor;

  BoardDirector({
    required this.name,
    required this.title,
    required this.company,
    required this.imageUrl,
    required this.backgroundColor,
  });
}

class BoardOfDirectorsCarousel extends StatefulWidget {
  const BoardOfDirectorsCarousel({Key? key}) : super(key: key);

  @override
  State<BoardOfDirectorsCarousel> createState() =>
      _BoardOfDirectorsCarouselState();
}

class _BoardOfDirectorsCarouselState extends State<BoardOfDirectorsCarousel>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  final List<BoardDirector> directors = [
    BoardDirector(
      name: "Sarah Mitchell",
      title: "CTO",
      company: "Tech Innovations Ltd",
      imageUrl:
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=300&h=300&fit=crop&crop=face",
      backgroundColor: const Color(0xFFFF8A80),
    ),
    BoardDirector(
      name: "AK Faisal",
      title: "Founder",
      company: "Malabar Gold & Diamonds",
      imageUrl:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face",
      backgroundColor: const Color(0xFFFFD180),
    ),
    BoardDirector(
      name: "Michael Chen",
      title: "COO",
      company: "Global Ventures Inc",
      imageUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face",
      backgroundColor: const Color(0xFF69F0AE),
    ),
    BoardDirector(
      name: "Emily Rodriguez",
      title: "CMO",
      company: "HealthTech Solutions",
      imageUrl:
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&h=300&fit=crop&crop=face",
      backgroundColor: const Color(0xFF82B1FF),
    ),
    BoardDirector(
      name: "James Thompson",
      title: "CFO",
      company: "Financial Partners Group",
      imageUrl:
          "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300&h=300&fit=crop&crop=face",
      backgroundColor: const Color(0xFFE1BEE7),
    ),
  ];

  void _rotateLeft() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + directors.length) % directors.length;
    });
  }

  void _rotateRight() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % directors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final int leftIndex =
        (_currentIndex - 1 + directors.length) % directors.length;
    final int rightIndex = (_currentIndex + 1) % directors.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1B2C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bord of Directors',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF64B5F6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Avatar Stack
              SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Left profile
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 90,
                      child: Transform.scale(
                        scale: 0.85,
                        child: Opacity(
                          opacity: 0.7,
                          child: GestureDetector(
                            onTap: _rotateLeft,
                            child: _buildProfileImage(
                              directors[(_currentIndex - 1 + directors.length) %
                                  directors.length],
                              80,
                              false,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right profile
                    Positioned(
                      right: MediaQuery.of(context).size.width / 2 - 90,
                      child: Transform.scale(
                        scale: 0.85,
                        child: Opacity(
                          opacity: 0.7,
                          child: GestureDetector(
                            onTap: _rotateRight,
                            child: _buildProfileImage(
                              directors[(_currentIndex + 1) % directors.length],
                              80,
                              false,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Center profile
                    Positioned(
                      child: GestureDetector(
                        onPanEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 200) {
                            _rotateLeft();
                          } else if (details.velocity.pixelsPerSecond.dx <
                              -200) {
                            _rotateRight();
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _buildProfileImage(
                            directors[_currentIndex],
                            110,
                            true,
                            key: ValueKey<int>(_currentIndex),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Name + Title
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey<int>(_currentIndex),
                  children: [
                    Text(
                      '${directors[_currentIndex].name} (${directors[_currentIndex].title})',
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      directors[_currentIndex].company,
                      style: TextStyle(
                        color: kWhite.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(directors.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? kWhite
                          : kWhite.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BoardDirector director, double size, bool isCenter,
      {Key? key}) {
    return Container(
      key: key,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            director.backgroundColor,
            director.backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: kWhite.withOpacity(isCenter ? 0.8 : 0.3),
          width: isCenter ? 3 : 1.5,
        ),
        boxShadow: isCenter
            ? [
                BoxShadow(
                  color: director.backgroundColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ClipOval(
        child: Image.network(
          director.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: director.backgroundColor,
              child: Icon(
                Icons.person,
                color: kWhite,
                size: size * 0.35,
              ),
            );
          },
        ),
      ),
    );
  }
}
