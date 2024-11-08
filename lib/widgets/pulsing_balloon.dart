import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class PulsingBalloon extends StatefulWidget {
  const PulsingBalloon({Key? key}) : super(key: key);

  @override
  State<PulsingBalloon> createState() => _PulsingBalloonState();
}

class _PulsingBalloonState extends State<PulsingBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.fastDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: AnimationConstants.minPulseScale,
      end: AnimationConstants.maxPulseScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          right: 100,
          top: 200,
          child: Transform.scale(
            scale: _animation.value,
            child: BalloonUtils.buildBalloon(
              color: Colors.purple,
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
