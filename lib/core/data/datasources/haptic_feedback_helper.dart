import 'package:vibration/vibration.dart';

class HapticFeedbackHelper {
  static Future<bool> _canVibrate() async {
    return await Vibration.hasVibrator();
  }

  static Future<bool> _hasAmplitudeControl() async {
    return await Vibration.hasAmplitudeControl();
  }

  // Light tap - works on all devices
  static Future<void> light() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      // Newer devices with amplitude control
      await Vibration.vibrate(duration: 50, amplitude: 128);
    } else {
      // Older devices - simple vibration
      await Vibration.vibrate(duration: 50);
    }
  }

  // Medium feedback
  static Future<void> medium() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(duration: 100, amplitude: 180);
    } else {
      await Vibration.vibrate(duration: 100);
    }
  }

  // Heavy feedback
  static Future<void> heavy() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(duration: 200, amplitude: 255);
    } else {
      await Vibration.vibrate(duration: 200);
    }
  }

  // Success pattern - works on all devices
  static Future<void> success() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(
        pattern: [0, 100, 50, 100],
        intensities: [0, 200, 0, 200],
      );
    } else {
      // Fallback for devices without amplitude control
      await Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }
  }

  // Error pattern
  static Future<void> error() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(
        pattern: [0, 150, 100, 150, 100, 150],
        intensities: [0, 255, 0, 255, 0, 255],
      );
    } else {
      await Vibration.vibrate(pattern: [0, 150, 100, 150, 100, 150]);
    }
  }

  // Warning pattern
  static Future<void> warning() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(
        pattern: [0, 200, 100, 200],
        intensities: [0, 220, 0, 220],
      );
    } else {
      await Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
  }

  // Selection/tap feedback
  static Future<void> selection() async {
    if (!await _canVibrate()) return;

    if (await _hasAmplitudeControl()) {
      await Vibration.vibrate(duration: 30, amplitude: 150);
    } else {
      await Vibration.vibrate(duration: 30);
    }
  }
}
