import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class TexturedBalloon extends StatefulWidget {
  final Color mainColor;
  final Color accentColor;

  const TexturedBalloon({
    Key? key,
    this.mainColor = Colors.red,
    this.accentColor = Colors.redAccent,
  }) : super(key: key);

  @override
  State<TexturedBalloon> createState() => _TexturedBalloonState();
}

class _TexturedBalloonState extends State<TexturedBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    )..repeat(reverse: true);

    // Create floating animation
    _floatAnimation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Create shimmer animation for highlight
    _shimmerAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
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
          right: 150,
          top: 150 + _floatAnimation.value,
          child: TweenAnimationBuilder<double>(
            duration: AnimationConstants.fastDuration,
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: BalloonUtils.buildBalloon(
                  color: widget.mainColor,
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

// Example usage with different color combinations
class TexturedBalloonDemo extends StatelessWidget {
  const TexturedBalloonDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        TexturedBalloon(
          mainColor: Colors.red,
          accentColor: Colors.redAccent,
        ),
        TexturedBalloon(
          mainColor: Colors.blue,
          accentColor: Colors.blueAccent,
        ),
      ],
    );
  }
}

// Optional extension for texture variations
extension TexturePresets on TexturedBalloon {
  static const List<Map<String, Color>> presetTextures = [
    {'main': Colors.red, 'accent': Colors.redAccent},
    {'main': Colors.blue, 'accent': Colors.blueAccent},
    {'main': Colors.green, 'accent': Colors.greenAccent},
    {'main': Colors.purple, 'accent': Colors.purpleAccent},
  ];

  static Map<String, Color> getRandomTexture() {
    return presetTextures[DateTime.now().millisecond % presetTextures.length];
  }
}
