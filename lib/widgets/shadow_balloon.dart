import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class ShadowBalloon extends StatefulWidget {
  final Color balloonColor;
  final Offset initialPosition;

  const ShadowBalloon({
    Key? key,
    this.balloonColor = Colors.blue,
    this.initialPosition = const Offset(100, 100),
  }) : super(key: key);

  @override
  State<ShadowBalloon> createState() => _ShadowBalloonState();
}

class _ShadowBalloonState extends State<ShadowBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize floating animation
    _controller = AnimationController(
      duration: AnimationConstants.slowDuration,
      vsync: this,
    )..repeat(reverse: true);

    // Create smooth floating effect
    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.initialPosition.dx,
          top: widget.initialPosition.dy + _floatAnimation.value,
          child: TweenAnimationBuilder<double>(
            duration: AnimationConstants.fastDuration,
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: BalloonUtils.buildBalloon(
                  color: widget.balloonColor,
                  scale: AnimationConstants.defaultBalloonScale,
                  withString: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Optional extension for balloon color variations
extension BalloonColors on ShadowBalloon {
  static const List<Color> presetColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  static Color getRandomColor() {
    return presetColors[DateTime.now().millisecond % presetColors.length];
  }
}
