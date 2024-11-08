class AnimationConstants {
  // Duration constants
  static const Duration defaultDuration = Duration(seconds: 2);
  static const Duration fastDuration = Duration(milliseconds: 1500);
  static const Duration slowDuration = Duration(seconds: 3);
  static const Duration cloudDuration = Duration(seconds: 15);

  // Size constants
  static const double defaultBalloonSize = 50.0;
  static const double defaultBalloonScale = 1.0;
  static const double smallBalloonScale = 0.8;
  static const double largeBalloonScale = 1.2;

  // Animation range constants
  static const double minPulseScale = 0.95;
  static const double maxPulseScale = 1.05;
  static const double minRotation = -1;
  static const double maxRotation = 1;

  // Position constants
  static const double defaultCloudHeight = 100.0;
  static const double defaultBalloonSpacing = 100.0;

  // Color opacity constants
  static const double highlightOpacity = 0.3;
  static const double cloudOpacity = 0.8;
}
