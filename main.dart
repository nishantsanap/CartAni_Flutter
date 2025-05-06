import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SwipeAnimationEnhanced());
  }
}

class SwipeAnimationEnhanced extends StatefulWidget {
  @override
  _SwipeAnimationEnhancedState createState() => _SwipeAnimationEnhancedState();
}

class _SwipeAnimationEnhancedState extends State<SwipeAnimationEnhanced> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  double _currentPage = 0.0;

  final List<String> cartItems = ['Cart 1', 'Cart 2', 'Cart 3', 'Cart 4'];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Cart')),
      body: Center(
        child: SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final progress = _currentPage - index;
              final scale = 1 - (progress.abs() * 0.25).clamp(0.0, 0.25);
              final opacity = 1 - (progress.abs() * 0.5).clamp(0.0, 0.5);
              final translateX = progress * -40;
              final rotate = progress * 0.06; // Radians for tilt

              return Transform.translate(
                offset: Offset(translateX, 0),
                child: Transform.rotate(
                  angle: rotate,
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: ParallaxCard(
                        text: cartItems[index],
                        depth: (1 - progress.abs()).clamp(0.0, 1.0),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ParallaxCard extends StatelessWidget {
  final String text;
  final double depth;

  ParallaxCard({required this.text, required this.depth});

  @override
  Widget build(BuildContext context) {
    final parallaxOffset = 20 * (1 - depth);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: 260,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2 + 0.3 * depth),
            blurRadius: 10,
            offset: Offset(3, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: parallaxOffset,  
            child: AnimatedRotation(turns: 1, duration: Duration.zero),          
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
