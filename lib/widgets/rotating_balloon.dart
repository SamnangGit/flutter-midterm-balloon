import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';
import 'dart:math' as math;

class RotatingBalloon extends StatefulWidget {
  const RotatingBalloon({Key? key}) : super(key: key);

  @override
  State<RotatingBalloon> createState() => _RotatingBalloonState();
}

class _RotatingBalloonState extends State<RotatingBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: AnimationConstants.minRotation,
      end: AnimationConstants.maxRotation,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: 200,
          top: 150,
          child: Transform.rotate(
            angle: _animation.value * math.pi,
            child: BalloonUtils.buildBalloon(
              color: Colors.green,
              scale: AnimationConstants.defaultBalloonScale,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
