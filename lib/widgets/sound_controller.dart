import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundController extends StatefulWidget {
  const SoundController({Key? key}) : super(key: key);

  @override
  State createState() => _SoundControllerState();
}

class _SoundControllerState extends State<SoundController> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playBackgroundSound();
  }

  void _playBackgroundSound() async {
    await _audioPlayer
        .play(AssetSource('wind_sound.mp3')); // Ensure asset path is correct
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBalloon(
        color: Colors.red, // Balloon color
        initialScale: 1.0, // Balloon scale for size
        withString: true, // Show string on balloon
      ),
    );
  }
}

class AnimatedBalloon extends StatefulWidget {
  final Color color;
  final double initialScale;
  final bool withString;

  const AnimatedBalloon({
    Key? key,
    required this.color,
    this.initialScale = AnimationConstants.defaultBalloonScale,
    this.withString = true,
  }) : super(key: key);

  @override
  State createState() => _AnimatedBalloonState();
}

class _AnimatedBalloonState extends State<AnimatedBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween(
      begin: AnimationConstants.minPulseScale,
      end: AnimationConstants.maxPulseScale,
    ).animate(_controller);

    _rotationAnimation = Tween(
      begin: AnimationConstants.minRotation,
      end: AnimationConstants.maxRotation,
    ).animate(_controller);
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
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value * widget.initialScale,
            child: BalloonUtils.buildBalloon(
              color: widget.color,
              scale: widget.initialScale,
              withString: widget.withString,
            ),
          ),
        );
      },
    );
  }
}
