import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class MultipleBalloons extends StatefulWidget {
  const MultipleBalloons({Key? key}) : super(key: key);

  @override
  State<MultipleBalloons> createState() => _MultipleBalloonsState();
}

class _MultipleBalloonsState extends State<MultipleBalloons>
    with TickerProviderStateMixin {
  final int numberOfBalloons = 5;
  final math.Random _random = math.Random();

  // Lists to store animation-related objects for each balloon
  final List<BalloonAnimationSet> _balloons = [];

  @override
  void initState() {
    super.initState();
    _initializeBalloons();
  }

  void _initializeBalloons() {
    for (int i = 0; i < numberOfBalloons; i++) {
      _balloons.add(_createBalloonAnimationSet(i));
    }
  }

  BalloonAnimationSet _createBalloonAnimationSet(int index) {
    // Vertical movement
    final verticalController = AnimationController(
      duration: Duration(seconds: 3 + _random.nextInt(3)),
      vsync: this,
    );
    final verticalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: verticalController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Horizontal swing
    final swingController = AnimationController(
      duration: Duration(seconds: 2 + _random.nextInt(3)),
      vsync: this,
    );
    final swingAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: swingController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Scale animation
    final scaleController = AnimationController(
      duration: Duration(seconds: 2 + _random.nextInt(2)),
      vsync: this,
    );
    final scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: scaleController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Wind effect
    final windController = AnimationController(
      duration: Duration(seconds: 4 + _random.nextInt(3)),
      vsync: this,
    );
    final windAnimation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: windController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Initial position
    final position = Offset(
      _random.nextDouble() * 300,
      _random.nextDouble() * 200 + 100, // Keep balloons in middle section
    );

    // Start animations with random delays
    Future.delayed(Duration(milliseconds: _random.nextInt(1000)), () {
      verticalController.repeat(reverse: true);
      swingController.repeat(reverse: true);
      scaleController.repeat(reverse: true);
      windController.repeat(reverse: true);
    });

    return BalloonAnimationSet(
      verticalController: verticalController,
      verticalAnimation: verticalAnimation,
      swingController: swingController,
      swingAnimation: swingAnimation,
      scaleController: scaleController,
      scaleAnimation: scaleAnimation,
      windController: windController,
      windAnimation: windAnimation,
      position: position,
      color: Colors.primaries[index % Colors.primaries.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(numberOfBalloons, (index) {
        final balloon = _balloons[index];
        return AnimatedBuilder(
          animation: Listenable.merge([
            balloon.verticalController,
            balloon.swingController,
            balloon.scaleController,
            balloon.windController,
          ]),
          builder: (context, child) {
            final verticalOffset =
                math.sin(balloon.verticalAnimation.value * math.pi) * 50;
            final horizontalOffset = balloon.swingAnimation.value * 30;
            final scale = balloon.scaleAnimation.value *
                AnimationConstants.smallBalloonScale;

            return Positioned(
              left: balloon.position.dx + horizontalOffset,
              top: balloon.position.dy + verticalOffset,
              child: Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: balloon.swingAnimation.value * 0.1,
                  child: BalloonUtils.buildBalloon(
                    color: balloon.color,
                    scale: 1.0,
                    windEffect: balloon.windAnimation.value,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var balloon in _balloons) {
      balloon.dispose();
    }
    super.dispose();
  }
}

// Helper class to organize animation-related objects for each balloon
class BalloonAnimationSet {
  final AnimationController verticalController;
  final Animation<double> verticalAnimation;
  final AnimationController swingController;
  final Animation<double> swingAnimation;
  final AnimationController scaleController;
  final Animation<double> scaleAnimation;
  final AnimationController windController;
  final Animation<double> windAnimation;
  final Offset position;
  final Color color;

  BalloonAnimationSet({
    required this.verticalController,
    required this.verticalAnimation,
    required this.swingController,
    required this.swingAnimation,
    required this.scaleController,
    required this.scaleAnimation,
    required this.windController,
    required this.windAnimation,
    required this.position,
    required this.color,
  });

  void dispose() {
    verticalController.dispose();
    swingController.dispose();
    scaleController.dispose();
    windController.dispose();
  }
}
