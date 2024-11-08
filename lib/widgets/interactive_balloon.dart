import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class InteractiveBalloon extends StatefulWidget {
  const InteractiveBalloon({Key? key}) : super(key: key);

  @override
  State<InteractiveBalloon> createState() => _InteractiveBalloonState();
}

class _InteractiveBalloonState extends State<InteractiveBalloon>
    with TickerProviderStateMixin {
  Offset _position = const Offset(100, 100);
  Offset _velocity = Offset.zero;
  bool _isDragging = false;

  // Animation controllers
  late AnimationController _idleController;
  late AnimationController _dragController;
  late AnimationController _releaseController;

  // Idle animations
  late Animation<double> _idleScaleAnimation;
  late Animation<double> _idleRotationAnimation;
  late Animation<double> _idleFloatAnimation;

  // Drag animation
  late Animation<double> _dragStretchAnimation;

  // Release spring animation
  late Animation<double> _releaseSpringAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Idle animations
    _idleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _idleScaleAnimation = Tween<double>(
      begin: AnimationConstants.minPulseScale,
      end: AnimationConstants.maxPulseScale,
    ).animate(CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOutSine,
    ));

    _idleRotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOutSine,
    ));

    _idleFloatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOutSine,
    ));

    // Drag animation
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _dragStretchAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _dragController,
      curve: Curves.easeOutCubic,
    ));

    // Release spring animation
    _releaseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _releaseSpringAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _releaseController,
      curve: Curves.elasticOut,
    ));
  }

  Offset _constrainPosition(Offset position) {
    final screenSize = MediaQuery.of(context).size;
    final balloonSize = AnimationConstants.defaultBalloonSize;
    return Offset(
      position.dx.clamp(0, screenSize.width - balloonSize),
      position.dy.clamp(0, screenSize.height - balloonSize),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _velocity = Offset.zero;
    });
    _dragController.forward();
    _idleController.stop();
    _releaseController.reset();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position = _constrainPosition(_position + details.delta);
      _velocity = details.delta;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    _dragController.reverse();
    _releaseController.forward(from: 0.0);
    _idleController.forward();

    // Add some momentum after release
    _addMomentum(details.velocity.pixelsPerSecond);
  }

  void _addMomentum(Offset velocity) {
    final momentumAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    Animation<Offset> momentumOffset = Tween<Offset>(
      begin: velocity * 0.1,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: momentumAnimation,
      curve: Curves.decelerate,
    ));

    momentumAnimation.addListener(() {
      setState(() {
        _position =
            _constrainPosition(_position + momentumOffset.value * 0.016);
      });
    });

    momentumAnimation.forward().then((_) => momentumAnimation.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleController,
        _dragController,
        _releaseController,
      ]),
      builder: (context, child) {
        double finalScale = _idleScaleAnimation.value;
        double finalRotation = _idleRotationAnimation.value;
        Offset finalPosition = _position;

        // Apply drag effects
        if (_isDragging) {
          finalScale *= _dragStretchAnimation.value;
          finalRotation += math.pi * 0.01 * _velocity.dx;
        }

        // Apply release spring effect
        if (_releaseController.isAnimating) {
          finalScale *= (1.0 + _releaseSpringAnimation.value * 0.2);
        }

        // Apply floating effect when not dragging
        if (!_isDragging) {
          finalPosition += Offset(0, _idleFloatAnimation.value);
        }

        return Positioned(
          left: finalPosition.dx,
          top: finalPosition.dy,
          child: GestureDetector(
            onPanStart: _handleDragStart,
            onPanUpdate: _handleDragUpdate,
            onPanEnd: _handleDragEnd,
            child: Transform.scale(
              scale: finalScale,
              child: Transform.rotate(
                angle: finalRotation,
                child: BalloonUtils.buildBalloon(
                  color: Colors.orange,
                  scale: AnimationConstants.defaultBalloonScale,
                  withString: true,
                  windEffect:
                      _velocity.dx * 0.1, // Add wind effect based on movement
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    _dragController.dispose();
    _releaseController.dispose();
    super.dispose();
  }
}



// add pop up error

// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../ulits/balloon_utils.dart';
// import '../config/animation_constants.dart';

// class InteractiveBalloon extends StatefulWidget {
//   final Color balloonColor;
//   final double initialX;
//   final double initialY;

//   const InteractiveBalloon({
//     Key? key,
//     this.balloonColor = Colors.orange,
//     this.initialX = 100,
//     this.initialY = 100,
//   }) : super(key: key);

//   @override
//   State<InteractiveBalloon> createState() => _InteractiveBalloonState();
// }

// class _InteractiveBalloonState extends State<InteractiveBalloon>
//     with TickerProviderStateMixin {
//   // Position and physics states
//   late Offset _position;
//   Offset _velocity = Offset.zero;
//   bool _isDragging = false;
//   bool _isPopped = false;
//   double _stringWave = 0.0;

//   // Animation controllers
//   late AnimationController _idleController;
//   late AnimationController _dragController;
//   late AnimationController _releaseController;
//   late AnimationController _popController;
//   late AnimationController _stringController;

//   // Animations
//   late Animation<double> _idleScaleAnimation;
//   late Animation<double> _idleRotationAnimation;
//   late Animation<double> _idleFloatAnimation;
//   late Animation<double> _dragStretchAnimation;
//   late Animation<double> _releaseSpringAnimation;
//   late Animation<double> _popScaleAnimation;
//   late Animation<double> _popOpacityAnimation;
//   late Animation<double> _stringWaveAnimation;

//   // Particle system
//   List<ParticleEffect> _particles = [];
//   final _random = math.Random();

//   @override
//   void initState() {
//     super.initState();
//     _position = Offset(widget.initialX, widget.initialY);
//     _initializeAnimations();
//     _startIdleAnimations();
//   }

//   void _initializeAnimations() {
//     // Idle animations setup
//     _idleController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     _stringController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     // More natural floating movement using curved animation
//     _idleScaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1.0, end: 1.05)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1.05, end: 1.0)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//     ]).animate(_idleController);

//     _idleRotationAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: -0.05, end: 0.05)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 0.05, end: -0.05)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//     ]).animate(_idleController);

//     _idleFloatAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: -8, end: 8)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 8, end: -8)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//     ]).animate(_idleController);

//     _stringWaveAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: -1, end: 1)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1, end: -1)
//             .chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 1,
//       ),
//     ]).animate(_stringController);

//     // Drag animation setup
//     _dragController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _dragStretchAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.3,
//     ).animate(CurvedAnimation(
//       parent: _dragController,
//       curve: Curves.elasticOut,
//     ));

//     // Release animation setup
//     _releaseController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _releaseSpringAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _releaseController,
//       curve: Curves.elasticOut,
//     ));

//     // Pop animation setup
//     _popController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _popScaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1.0, end: 1.3)
//             .chain(CurveTween(curve: Curves.easeOutExpo)),
//         weight: 0.3,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1.3, end: 0.0)
//             .chain(CurveTween(curve: Curves.easeInExpo)),
//         weight: 0.7,
//       ),
//     ]).animate(_popController);

//     _popOpacityAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 1.0, end: 0.8)
//             .chain(CurveTween(curve: Curves.easeOut)),
//         weight: 0.2,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(begin: 0.8, end: 0.0)
//             .chain(CurveTween(curve: Curves.easeIn)),
//         weight: 0.8,
//       ),
//     ]).animate(_popController);
//   }

//   void _startIdleAnimations() {
//     _idleController.repeat();
//     _stringController.repeat();
//   }

//   void _handleDoubleTap() {
//     if (_isPopped) return;
//     _popBalloon();
//   }

//   void _popBalloon() {
//     setState(() {
//       _isPopped = true;
//       _generateParticles();
//     });

//     _idleController.stop();
//     _stringController.stop();
//     _popController.forward().then((_) {
//       setState(() {
//         _particles.clear();
//       });
//     });
//   }

//   void _generateParticles() {
//     final baseColor = widget.balloonColor;
//     final hslColor = HSLColor.fromColor(baseColor);

//     _particles = List.generate(40, (index) {
//       final angle = index * (math.pi * 2) / 40;
//       final velocity = _random.nextDouble() * 3 + 2;

//       // Create variations of the balloon color
//       final particleColor = HSLColor.fromAHSL(
//         1.0,
//         hslColor.hue + _random.nextDouble() * 30 - 15,
//         hslColor.saturation,
//         math.max(
//             0.3,
//             math.min(
//                 0.7, hslColor.lightness + _random.nextDouble() * 0.4 - 0.2)),
//       ).toColor();

//       return ParticleEffect(
//         position: Offset.zero,
//         velocity: Offset(
//           velocity * math.cos(angle),
//           velocity * math.sin(angle),
//         ),
//         color: particleColor,
//         size: _random.nextDouble() * 12 + 4,
//         rotationSpeed: _random.nextDouble() * 0.2 - 0.1,
//         fadeRate: _random.nextDouble() * 0.05 + 0.02,
//       );
//     });
//   }

//   void _updateParticles(double dt) {
//     for (var particle in _particles) {
//       particle.update(dt);
//     }
//   }

//   void _handleDragStart(DragStartDetails details) {
//     if (_isPopped) return;
//     setState(() {
//       _isDragging = true;
//       _velocity = Offset.zero;
//     });
//     _dragController.forward();
//     _idleController.stop();
//     _releaseController.reset();
//   }

//   void _handleDragUpdate(DragUpdateDetails details) {
//     if (_isPopped) return;
//     setState(() {
//       _position = _constrainPosition(_position + details.delta);
//       _velocity = details.delta;
//       _stringWave = _velocity.dx * 0.1;
//     });
//   }

//   void _handleDragEnd(DragEndDetails details) {
//     if (_isPopped) return;
//     setState(() {
//       _isDragging = false;
//       _stringWave = 0.0;
//     });
//     _dragController.reverse();
//     _releaseController.forward(from: 0.0);
//     _startIdleAnimations();
//     _addMomentum(details.velocity.pixelsPerSecond);
//   }

//   Offset _constrainPosition(Offset position) {
//     final size = MediaQuery.of(context).size;
//     return Offset(
//       position.dx.clamp(0, size.width - 100),
//       position.dy.clamp(0, size.height - 150),
//     );
//   }

//   void _addMomentum(Offset velocity) {
//     final momentumAnimation = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     Animation<Offset> momentumOffset = Tween<Offset>(
//       begin: velocity * 0.2,
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: momentumAnimation,
//       curve: Curves.easeOutCubic,
//     ));

//     momentumAnimation.addListener(() {
//       setState(() {
//         _position =
//             _constrainPosition(_position + momentumOffset.value * 0.016);
//       });
//     });

//     momentumAnimation.forward().then((_) => momentumAnimation.dispose());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _idleController,
//         _dragController,
//         _releaseController,
//         _popController,
//         _stringController,
//       ]),
//       builder: (context, child) {
//         if (_isPopped && !_popController.isAnimating && _particles.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         double finalScale = _idleScaleAnimation.value;
//         double finalRotation = _idleRotationAnimation.value;
//         Offset finalPosition = _position;

//         // Apply drag effects
//         if (_isDragging) {
//           finalScale *= _dragStretchAnimation.value;
//           finalRotation += math.pi * 0.01 * _velocity.dx;
//         }

//         // Apply release spring effect
//         if (_releaseController.isAnimating) {
//           finalScale *= (1.0 + _releaseSpringAnimation.value * 0.2);
//         }

//         // Apply pop effect
//         if (_isPopped) {
//           finalScale *= _popScaleAnimation.value;
//           _updateParticles(0.016);
//         }

//         // Apply floating effect when not dragging
//         if (!_isDragging) {
//           finalPosition += Offset(
//             _idleRotationAnimation.value * 5,
//             _idleFloatAnimation.value,
//           );
//         }

//         return Positioned(
//           left: finalPosition.dx,
//           top: finalPosition.dy,
//           child: GestureDetector(
//             onPanStart: _handleDragStart,
//             onPanUpdate: _handleDragUpdate,
//             onPanEnd: _handleDragEnd,
//             onDoubleTap: _handleDoubleTap,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Balloon
//                 if (!_isPopped || _popController.isAnimating)
//                   Opacity(
//                     opacity: _isPopped ? _popOpacityAnimation.value : 1.0,
//                     child: Transform.scale(
//                       scale: finalScale,
//                       child: Transform.rotate(
//                         angle: finalRotation,
//                         child: BalloonUtils.(
//                           color: widget.balloonColor,
//                           scale: AnimationConstants.defaultBalloonScale,
//                           withString: !_isPopped,
//                           windEffect: _isDragging
//                               ? _velocity.dx * 0.1
//                               : _stringWaveAnimation.value * 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 // Particles
//                 if (_isPopped)
//                   ..._particles.map((particle) => Positioned(
//                         left: particle.position.dx,
//                         top: particle.position.dy,
//                         child: Transform.rotate(
//                           angle: particle.rotation,
//                           child: Container(
//                             width: particle.size,
//                             height: particle.size,
//                             decoration: BoxDecoration(
//                               color: particle.color.withOpacity(
//                                   particle.opacity *
//                                       _popOpacityAnimation.value),
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: particle.color.withOpacity(0.5 *
//                                       particle.opacity *
//                                       _popOpacityAnimation.value),
//                                   blurRadius: 3,
//                                   spreadRadius: 1,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _idleController.dispose();
//     _dragController.dispose();
//     _releaseController.dispose();
//     _popController.dispose();
//     _stringController.dispose();
//     super.dispose();
//   }
// }

// class ParticleEffect {
//   Offset position;
//   Offset velocity;
//   Color color;
//   double size;
//   double rotation;
//   double rotationSpeed;
//   double opacity;
//   double fadeRate;

//   ParticleEffect({
//     this.position = Offset.zero,
//     required this.velocity,
//     required this.color,
//     required this.size,
//     this.rotation = 0.0,
//     required this.rotationSpeed,
//     this.opacity = 1.0,
//     required this.fadeRate,
//   });

//   void update(double dt) {
//     // Update position based on velocity
//     position += velocity * dt * 60;

//     // Apply gravity effect
//     velocity += const Offset(0, 0.5) * dt * 60;

//     // Apply air resistance
//     velocity *= 0.99;

//     // Update rotation
//     rotation += rotationSpeed * dt * 60;

//     // Fade out the particle
//     opacity = math.max(0, opacity - fadeRate);

//     // Gradually reduce size
//     size *= 0.995;
//   }

//   bool get isDead => opacity <= 0 || size <= 1;
// }

// // Extension for using the Interactive Balloon
// extension BalloonUtils on InteractiveBalloon {
//   static Widget createBalloonGroup({
//     required BuildContext context,
//     int count = 3,
//     List<Color> colors = const [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.purple,
//       Colors.orange,
//     ],
//   }) {
//     return Stack(
//       children: List.generate(count, (index) {
//         final random = math.Random();
//         return InteractiveBalloon(
//           balloonColor: colors[random.nextInt(colors.length)],
//           initialX:
//               random.nextDouble() * (MediaQuery.of(context).size.width - 100),
//           initialY:
//               random.nextDouble() * (MediaQuery.of(context).size.height - 200),
//         );
//       }),
//     );
//   }
// }
