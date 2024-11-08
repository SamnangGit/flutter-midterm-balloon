import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -0.3, // Changed from -1.0 to make entrance/exit smoother
      end: 1.3, // Changed from 1.0 to make entrance/exit smoother
    ).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white],
            ),
          ),
        ),
        // Multiple clouds with different sizes and positions
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width *
                    (_animation.value + (index * 0.3)),
                top: 50.0 + (index * 80), // Different heights for each cloud
                child: _buildCloud(index),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildCloud(int index) {
    return Row(
      children: [
        Icon(
          Icons.cloud,
          size: 80 - (index * 10), // Different sizes for variety
          color: Colors.white.withOpacity(0.8),
        ),
        Transform.translate(
          offset: const Offset(-40, 0),
          child: Icon(
            Icons.cloud,
            size: 60 - (index * 8), // Smaller overlapping cloud
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
