// import 'package:flutter/material.dart';
// import '../ulits/balloon_utils.dart';
// import '../config/animation_constants.dart';

// class SequentialBalloon extends StatefulWidget {
//   const SequentialBalloon({Key? key}) : super(key: key);

//   @override
//   State<SequentialBalloon> createState() => _SequentialBalloonState();
// }

// class _SequentialBalloonState extends State<SequentialBalloon>
//     with TickerProviderStateMixin {
//   late AnimationController _floatController;
//   late AnimationController _scaleController;
//   late Animation<double> _floatAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startSequence();
//   }

//   void _initializeAnimations() {
//     _floatController = AnimationController(
//       duration: AnimationConstants.slowDuration,
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: AnimationConstants.defaultDuration,
//       vsync: this,
//     );

//     _floatAnimation = Tween<double>(begin: 0, end: 1).animate(_floatController);
//     _scaleAnimation = Tween<double>(begin: 1, end: 0).animate(_scaleController);
//   }

//   void _startSequence() {
//     _floatController.forward().then((_) {
//       _scaleController.forward();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
//       builder: (context, child) {
//         return Positioned(
//           left: 50,
//           bottom: _floatAnimation.value * MediaQuery.of(context).size.height,
//           child: Transform.scale(
//             scale: _scaleAnimation.value,
//             child: BalloonUtils.buildBalloon(
//               color: Colors.yellow,
//               scale: AnimationConstants.defaultBalloonScale,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _floatController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class SequentialBalloon extends StatefulWidget {
  const SequentialBalloon({Key? key}) : super(key: key);

  @override
  State<SequentialBalloon> createState() => _SequentialBalloonState();
}

class _SequentialBalloonState extends State<SequentialBalloon>
    with TickerProviderStateMixin {
  late List<AnimationController> _floatControllers;
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _floatAnimations;
  late List<Animation<double>> _scaleAnimations;

  final int _balloonCount = 6; // Number of balloons to appear sequentially
  int _currentBalloonIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startNextBalloon();
  }

  void _initializeAnimations() {
    _floatControllers = List.generate(
      _balloonCount,
      (index) => AnimationController(
        duration: AnimationConstants.slowDuration,
        vsync: this,
      ),
    );

    _scaleControllers = List.generate(
      _balloonCount,
      (index) => AnimationController(
        duration: AnimationConstants.defaultDuration,
        vsync: this,
      ),
    );

    _floatAnimations = _floatControllers
        .map(
            (controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    _scaleAnimations = _scaleControllers
        .map(
            (controller) => Tween<double>(begin: 1, end: 0).animate(controller))
        .toList();
  }

  void _startNextBalloon() {
    if (_currentBalloonIndex < _balloonCount) {
      _floatControllers[_currentBalloonIndex].forward().then((_) {
        _scaleControllers[_currentBalloonIndex].forward().then((_) {
          _currentBalloonIndex++;
          _startNextBalloon();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(_balloonCount, (index) {
        return AnimatedBuilder(
          animation: Listenable.merge(
              [_floatAnimations[index], _scaleAnimations[index]]),
          builder: (context, child) {
            return Positioned(
              left: 50.0 + index * 10, // Slight offset for each balloon
              bottom: _floatAnimations[index].value *
                  MediaQuery.of(context).size.height,
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: BalloonUtils.buildBalloon(
                  color: Colors.cyan,
                  scale: AnimationConstants.defaultBalloonScale,
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
    for (var controller in _floatControllers) {
      controller.dispose();
    }
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
