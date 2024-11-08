import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';
import 'dart:math' as math;

class EasingBalloon extends StatefulWidget {
  const EasingBalloon({Key? key}) : super(key: key);

  @override
  State<EasingBalloon> createState() => _EasingBalloonState();
}

class _EasingBalloonState extends State<EasingBalloon>
    with TickerProviderStateMixin {
  // Main vertical movement controller
  late AnimationController _verticalController;
  late Animation<double> _verticalAnimation;

  // Horizontal swing controller
  late AnimationController _swingController;
  late Animation<double> _swingAnimation;

  // Scale "bobbing" controller
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Wind effect controller
  late AnimationController _windController;
  late Animation<double> _windAnimation;

  // Random offset for natural movement
  final random = math.Random();

  @override
  void initState() {
    super.initState();

    // Setup vertical movement
    _verticalController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _verticalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _verticalController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Setup horizontal swing
    _swingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _swingAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: _swingController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Setup scale bobbing
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Setup wind effect
    _windController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _windAnimation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _windController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Start animations with slight delays for more natural movement
    Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
      _verticalController.repeat(reverse: true);
    });

    Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
      _swingController.repeat(reverse: true);
    });

    Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
      _scaleController.repeat(reverse: true);
    });

    Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
      _windController.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _verticalAnimation,
        _swingAnimation,
        _scaleAnimation,
        _windAnimation,
      ]),
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        // Calculate vertical position
        final verticalPosition = _verticalAnimation.value * screenHeight * 0.3 +
            screenHeight * 0.2; // Keep balloon in middle third of screen

        // Calculate horizontal position with swing
        final horizontalPosition = screenWidth / 2 +
            (_swingAnimation.value * 30.0); // Swing range of 60 pixels

        // Calculate current scale
        final currentScale =
            _scaleAnimation.value * AnimationConstants.defaultBalloonScale;

        return Positioned(
          left: horizontalPosition - (50 * currentScale), // Center balloon
          bottom: verticalPosition,
          child: Transform.scale(
            scale: currentScale,
            child: Transform.rotate(
              angle: _swingAnimation.value * 0.1, // Slight rotation with swing
              child: BalloonUtils.buildBalloon(
                color: Colors.red,
                scale: 1.0, // Scale is handled by Transform.scale now
                windEffect: _windAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _swingController.dispose();
    _scaleController.dispose();
    _windController.dispose();
    super.dispose();
  }
}
