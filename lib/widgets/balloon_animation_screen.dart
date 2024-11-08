import 'package:flutter/material.dart';
import 'easing_balloon.dart';
import 'shadow_balloon.dart';
import 'rotating_balloon.dart';
import 'pulsing_balloon.dart';
import 'animated_background.dart';
import 'textured_balloon.dart';
import 'interactive_balloon.dart';
import 'sound_controller.dart';
import 'sequential_balloon.dart';
import 'multiple_balloons.dart';

class BalloonAnimationScreen extends StatelessWidget {
  const BalloonAnimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(),
          MultipleBalloons(),
          EasingBalloon(),
          ShadowBalloon(),
          RotatingBalloon(),
          PulsingBalloon(),
          TexturedBalloon(),
          InteractiveBalloon(),
          SequentialBalloon(),
          SoundController(),
        ],
      ),
    );
  }
}
