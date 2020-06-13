import 'dart:math';

import '../coordinates.dart';
import 'double_util.dart';
import 'math.dart';

class QiblaUtil {
  static final Coordinates makkah = Coordinates(21.4225241, 39.8261818);

  static double calculateQiblaDirection(Coordinates coordinates) {
    // Equation from "Spherical Trigonometry For the use of colleges and schools" page 50
    final longitudeDelta =
        radians(makkah.longitude) - radians(coordinates.longitude);
    final latitudeRadians = radians(coordinates.latitude);
    final term1 = sin(longitudeDelta);
    final term2 = cos(latitudeRadians) * tan(radians(makkah.latitude));
    final term3 = sin(latitudeRadians) * cos(longitudeDelta);

    final angle = atan2(term1, term2 - term3);
    return DoubleUtil.unwindAngle(degrees(angle));
  }
}
