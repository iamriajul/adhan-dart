import 'dart:math';

import 'astronomical.dart';
import 'calendrical_helper.dart';
import 'double_util.dart';
import 'math.dart';

class SolarCoordinates {
  /// The declination of the sun, the angle between
  /// the rays of the Sun and the plane of the Earth's
  /// equator, in degrees.
  double? _declination;
  double? get declination => _declination;

  ///  Right ascension of the Sun, the angular distance on the
  /// celestial equator from the vernal equinox to the hour circle,
  /// in degrees.
  double? _rightAscension;
  double? get rightAscension => _rightAscension;

  ///  Apparent sidereal time, the hour angle of the vernal
  /// equinox, in degrees.
  double? _apparentSiderealTime;
  double? get apparentSiderealTime => _apparentSiderealTime;

  SolarCoordinates(double julianDay) {
    final T = CalendricalHelper.julianCentury(julianDay);
    final L0 = Astronomical.meanSolarLongitude(/* julianCentury */ T);
    final Lp = Astronomical.meanLunarLongitude(/* julianCentury */ T);
    final omega =
        Astronomical.ascendingLunarNodeLongitude(/* julianCentury */ T);
    final lambda = radians(Astronomical.apparentSolarLongitude(
        /* julianCentury*/ T,
        /* meanLongitude */ L0));

    final theta0 = Astronomical.meanSiderealTime(/* julianCentury */ T);
    final deltaPsi = Astronomical.nutationInLongitude(
        /* julianCentury */ T,
        /* solarLongitude */ L0,
        /* lunarLongitude */ Lp,
        /* ascendingNode */ omega);
    final deltaEpsilon = Astronomical.nutationInObliquity(
        /* julianCentury */ T,
        /* solarLongitude */ L0,
        /* lunarLongitude */ Lp,
        /* ascendingNode */ omega);

    final epsilon0 =
        Astronomical.meanObliquityOfTheEcliptic(/* julianCentury */ T);
    final epsilonApp = radians(Astronomical.apparentObliquityOfTheEcliptic(
        /* julianCentury */ T,
        /* meanObliquityOfTheEcliptic */ epsilon0));

    /* Equation from Astronomical Algorithms page 165 */
    _declination = degrees(asin(sin(epsilonApp) * sin(lambda)));

    /* Equation from Astronomical Algorithms page 165 */
    _rightAscension = DoubleUtil.unwindAngle(
        degrees(atan2(cos(epsilonApp) * sin(lambda), cos(lambda))));

    /* Equation from Astronomical Algorithms page 88 */
    _apparentSiderealTime = theta0 +
        (((deltaPsi * 3600) * cos(radians(epsilon0 + deltaEpsilon))) / 3600);
  }
}
