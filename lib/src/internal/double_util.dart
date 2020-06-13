class DoubleUtil {
  static double normalizeWithBound(double value, double max) {
    return value - (max * ((value / max).floorToDouble()));
  }

  static double unwindAngle(double value) {
    return normalizeWithBound(value, 360);
  }

  static double closestAngle(double angle) {
    if (angle >= -180 && angle <= 180) {
      return angle;
    }
    return angle - (360 * (angle / 360).roundToDouble());
  }
}
