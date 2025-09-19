import 'package:adhan/src/data/calendar_util.dart';
import 'package:adhan/src/extensions/datetime.dart';

import 'calculation_method.dart';
import 'calculation_parameters.dart';
import 'coordinates.dart';
import 'data/date_components.dart';
import 'data/time_components.dart';
import 'internal/solar_time.dart';
import 'madhab.dart';
import 'polar_circle_resolution.dart';
import 'polar_circle_resolvers.dart';
import 'prayer.dart';

class PrayerTimes {
  late DateTime _fajr;
  DateTime get fajr => _fajr;

  late DateTime _sunrise;
  DateTime get sunrise => _sunrise;

  late DateTime _dhuhr;
  DateTime get dhuhr => _dhuhr;

  late DateTime _asr;
  DateTime get asr => _asr;

  late DateTime _maghrib;
  DateTime get maghrib => _maghrib;

  late DateTime _isha;
  DateTime get isha => _isha;

  // If you give a UTC Offset then Prayer Times will convert local(with device timezone) time
  // to UTC and then add the offset.
  final Duration? utcOffset;

  final Coordinates coordinates;

  late DateComponents _dateComponents;

  DateComponents get dateComponents => _dateComponents;

  final CalculationParameters calculationParameters;

  late bool _polarResolutionApplied;
  bool get polarResolutionApplied => _polarResolutionApplied;

  late PolarCircleResolution? _polarResolutionStrategy;
  PolarCircleResolution? get polarResolutionStrategy => _polarResolutionStrategy;

  /// Calculate PrayerTimes and Output Local Times By Default.
  /// If you provide utcOffset then it will Output UTC with Offset Applied Times.
  ///
  /// [coordinates] the coordinates of the location
  /// [dateComponents] the date components for that location
  /// [calculationParameters] the parameters for the calculation
  factory PrayerTimes(Coordinates coordinates, DateComponents dateComponents,
      CalculationParameters calculationParameters,
      {Duration? utcOffset}) {
    return PrayerTimes._(
        coordinates,
        CalendarUtil.resolveTimeByDateComponents(dateComponents),
        calculationParameters,
        utcOffset: utcOffset);
  }

  /// Calculate Today's PrayerTimes and Output Local Times By Default.
  /// If you provide utcOffset then it will Output UTC with Offset Applied Times.
  ///
  /// [coordinates] the coordinates of the location
  /// [calculationParameters] the parameters for the calculation
  factory PrayerTimes.today(
      Coordinates coordinates, CalculationParameters calculationParameters,
      {Duration? utcOffset}) {
    return PrayerTimes._(
        coordinates,
        CalendarUtil.resolveTimeByDateComponents(
            DateComponents.from(DateTime.now())),
        calculationParameters,
        utcOffset: utcOffset);
  }

  /// Calculate PrayerTimes and Output UTC Times.
  ///
  /// [coordinates] the coordinates of the location
  /// [dateComponents] the date components for that location
  /// [calculationParameters] the parameters for the calculation
  factory PrayerTimes.utc(
      Coordinates coordinates,
      DateComponents dateComponents,
      CalculationParameters calculationParameters) {
    return PrayerTimes._(
        coordinates,
        CalendarUtil.resolveTimeByDateComponents(dateComponents),
        calculationParameters,
        utcOffset: Duration());
  }

  /// Calculate PrayerTimes and Output UTC with Offset Applied Times.
  ///
  /// [coordinates] the coordinates of the location
  /// [dateComponents] the date components for that location
  /// [calculationParameters] the parameters for the calculation
  factory PrayerTimes.utcOffset(
      Coordinates coordinates,
      DateComponents dateComponents,
      CalculationParameters calculationParameters,
      Duration utcOffset) {
    return PrayerTimes._(
        coordinates,
        CalendarUtil.resolveTimeByDateComponents(dateComponents),
        calculationParameters,
        utcOffset: utcOffset);
  }

  PrayerTimes._(this.coordinates, DateTime _date, this.calculationParameters,
      {this.utcOffset}) {
    bool _valid(double value) => !(value.isInfinite || value.isNaN);

    late double _value;

    final date = _date.toUtc();
    _dateComponents = DateComponents.from(date);

    DateTime? tempFajr;
    late DateTime tempSunrise;
    late DateTime tempDhuhr;
    late DateTime tempAsr;
    late DateTime tempMaghrib;
    DateTime? tempIsha;

    final year = date.year;
    final dayOfYear = date.dayOfYear;

    // Initialize solar time calculation
    late SolarTime solarTime;
    late SolarTime tomorrowSolarTime;
    late DateTime tomorrow;
    late Coordinates calculationCoordinates;

    // Apply polar circle resolution if needed
    final initialSolarTime = SolarTime(date, coordinates);
    final initialTomorrowSolarTime = SolarTime(date.add(Duration(days: 1)), coordinates);

    bool resolutionApplied = false;
    PolarCircleResolution? usedStrategy;

    if (!PolarCircleResolutionUtils.isValidSolarTimePair(initialSolarTime, initialTomorrowSolarTime) &&
        calculationParameters.polarCircleResolution != PolarCircleResolution.unresolved) {
      // Apply resolution strategy
      final resolutionResult = PolarCircleResolver.resolve(
        calculationParameters.polarCircleResolution,
        coordinates,
        date,
      );

      if (resolutionResult != null) {
        solarTime = resolutionResult.solarTime;
        tomorrowSolarTime = resolutionResult.tomorrowSolarTime;
        tomorrow = resolutionResult.tomorrow;
        calculationCoordinates = resolutionResult.coordinates;
        resolutionApplied = true;
        usedStrategy = calculationParameters.polarCircleResolution;
      } else {
        // Resolution failed, use original coordinates (will result in undefined times)
        solarTime = initialSolarTime;
        tomorrowSolarTime = initialTomorrowSolarTime;
        tomorrow = date.add(Duration(days: 1));
        calculationCoordinates = coordinates;
      }
    } else {
      // No resolution needed or configured
      solarTime = initialSolarTime;
      tomorrowSolarTime = initialTomorrowSolarTime;
      tomorrow = date.add(Duration(days: 1));
      calculationCoordinates = coordinates;
    }

    // Store resolution info in instance variables (using private fields and getters)
    _polarResolutionApplied = resolutionApplied;
    _polarResolutionStrategy = usedStrategy;

    var timeComponents = TimeComponents.fromDouble(solarTime.transit);
    final transit = timeComponents.dateComponents(date);

    // Calculate sunrise and sunset
    DateTime sunriseComponents;
    DateTime sunsetComponents;

    if (_valid(solarTime.sunrise)) {
      timeComponents = TimeComponents.fromDouble(solarTime.sunrise);
      sunriseComponents = timeComponents.dateComponents(date);
    } else {
      // Sunrise cannot be calculated (polar night)
      sunriseComponents = date; // Placeholder, will be handled by safe bounds
    }

    if (_valid(solarTime.sunset)) {
      timeComponents = TimeComponents.fromDouble(solarTime.sunset);
      sunsetComponents = timeComponents.dateComponents(date);
    } else {
      // Sunset cannot be calculated (midnight sun)
      sunsetComponents = date; // Placeholder, will be handled by safe bounds
    }

    // Calculate tomorrow's sunrise for night length calculation
    DateTime tomorrowSunriseComponents;
    if (_valid(tomorrowSolarTime.sunrise)) {
      tomorrowSunriseComponents = TimeComponents.fromDouble(tomorrowSolarTime.sunrise).dateComponents(tomorrow);
    } else {
      // Tomorrow's sunrise cannot be calculated, use approximation
      tomorrowSunriseComponents = transit.add(Duration(hours: 24));
    }

    tempDhuhr = transit;
    tempSunrise = sunriseComponents;

    timeComponents = TimeComponents.fromDouble(
        solarTime.afternoon(calculationParameters.madhab.getShadowLength()));
    tempAsr = timeComponents.dateComponents(date);

    // get night length
    final tomorrowSunrise = tomorrowSunriseComponents;
    final night = tomorrowSunrise.millisecondsSinceEpoch -
        sunsetComponents.millisecondsSinceEpoch;

    // Handle Fajr calculation
    _value = solarTime.hourAngle(-calculationParameters.fajrAngle, false);
    if (_valid(_value)) {
      timeComponents = TimeComponents.fromDouble(_value);
      tempFajr = timeComponents.dateComponents(date);
    }

    if (calculationParameters.method ==
            CalculationMethod.moon_sighting_committee &&
        coordinates.latitude >= 55) {
      tempFajr = sunriseComponents.add(Duration(seconds: -1 * night ~/ 7000));
    }

    final nightPortions = calculationParameters.nightPortions();

    DateTime safeFajr;
    if (calculationParameters.method ==
        CalculationMethod.moon_sighting_committee) {
      safeFajr = _seasonAdjustedMorningTwilight(
          coordinates.latitude, dayOfYear, year, sunriseComponents);
    } else {
      final portion = nightPortions.fajr;
      final nightFraction = portion * night ~/ 1000;
      safeFajr = sunriseComponents.add(Duration(seconds: -1 * nightFraction));
    }

    if (tempFajr == null || tempFajr.isBefore(safeFajr)) {
      tempFajr = safeFajr;
    }

    // Isha calculation with check against safe value
    if (calculationParameters.ishaInterval > 0) {
      tempIsha = sunsetComponents
          .add(Duration(seconds: calculationParameters.ishaInterval * 60));
    } else {
      // Handle Isha calculation
      _value = solarTime.hourAngle(-calculationParameters.ishaAngle!, true);

      if (calculationParameters.ishaAngle != null && _valid(_value)) {
        timeComponents = TimeComponents.fromDouble(
            solarTime.hourAngle(-calculationParameters.ishaAngle!, true));
        tempIsha = timeComponents.dateComponents(date);
      }

      if (calculationParameters.method ==
              CalculationMethod.moon_sighting_committee &&
          coordinates.latitude >= 55) {
        final nightFraction = night ~/ 7000;
        tempIsha = sunsetComponents.add(Duration(seconds: nightFraction));
      }

      DateTime safeIsha;
      if (calculationParameters.method ==
          CalculationMethod.moon_sighting_committee) {
        safeIsha = PrayerTimes._seasonAdjustedEveningTwilight(
            coordinates.latitude, dayOfYear, year, sunsetComponents);
      } else {
        final portion = nightPortions.isha;
        final nightFraction = portion * night ~/ 1000;
        safeIsha = sunsetComponents.add(Duration(seconds: nightFraction));
      }

      if (tempIsha == null || (tempIsha.isAfter(safeIsha))) {
        tempIsha = safeIsha;
      }
    }

    tempMaghrib = sunsetComponents;
    if (calculationParameters.maghribAngle != null) {
      // Handle angle-based Maghrib calculation
      final angleBasedMaghrib = TimeComponents.fromDouble(solarTime.hourAngle(
              -1 * calculationParameters.maghribAngle!, true))
          .dateComponents(date);
      if (sunsetComponents.isBefore(angleBasedMaghrib) &&
          tempIsha.isAfter(angleBasedMaghrib)) {
        tempMaghrib = angleBasedMaghrib;
      }
    }

    // Assign final times to public struct members with all offsets
    _fajr = CalendarUtil.roundedMinute(tempFajr
        .add(Duration(minutes: calculationParameters.adjustments.fajr))
        .add(Duration(minutes: calculationParameters.methodAdjustments.fajr))
        .toLocal());
    _sunrise = CalendarUtil.roundedMinute(tempSunrise
        .add(Duration(minutes: calculationParameters.adjustments.sunrise))
        .add(Duration(minutes: calculationParameters.methodAdjustments.sunrise))
        .toLocal());
    _dhuhr = CalendarUtil.roundedMinute(tempDhuhr
        .add(Duration(minutes: calculationParameters.adjustments.dhuhr))
        .add(Duration(minutes: calculationParameters.methodAdjustments.dhuhr))
        .toLocal());
    _asr = CalendarUtil.roundedMinute(tempAsr
        .add(Duration(minutes: calculationParameters.adjustments.asr))
        .add(Duration(minutes: calculationParameters.methodAdjustments.asr))
        .toLocal());
    _maghrib = CalendarUtil.roundedMinute(tempMaghrib
        .add(Duration(minutes: calculationParameters.adjustments.maghrib))
        .add(Duration(minutes: calculationParameters.methodAdjustments.maghrib))
        .toLocal());
    _isha = CalendarUtil.roundedMinute(tempIsha
        .add(Duration(minutes: calculationParameters.adjustments.isha))
        .add(Duration(minutes: calculationParameters.methodAdjustments.isha))
        .toLocal());

    if (utcOffset != null) {
      _fajr = fajr.toUtc().add(utcOffset!);
      _sunrise = sunrise.toUtc().add(utcOffset!);
      _dhuhr = dhuhr.toUtc().add(utcOffset!);
      _asr = asr.toUtc().add(utcOffset!);
      _maghrib = maghrib.toUtc().add(utcOffset!);
      _isha = isha.toUtc().add(utcOffset!);
    }
  }

  Prayer currentPrayer() {
    return currentPrayerByDateTime(DateTime.now());
  }

  Prayer currentPrayerByDateTime(DateTime time) {
    final when = time.millisecondsSinceEpoch;
    if (isha.millisecondsSinceEpoch - when <= 0) {
      return Prayer.isha;
    } else if (maghrib.millisecondsSinceEpoch - when <= 0) {
      return Prayer.maghrib;
    } else if (asr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.asr;
    } else if (dhuhr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.dhuhr;
    } else if (sunrise.millisecondsSinceEpoch - when <= 0) {
      return Prayer.sunrise;
    } else if (fajr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.fajr;
    } else {
      return Prayer.none;
    }
  }

  Prayer nextPrayer() {
    return nextPrayerByDateTime(DateTime.now());
  }

  Prayer nextPrayerByDateTime(DateTime time) {
    final when = time.millisecondsSinceEpoch;
    if (isha.millisecondsSinceEpoch - when <= 0) {
      return Prayer.none;
    } else if (maghrib.millisecondsSinceEpoch - when <= 0) {
      return Prayer.isha;
    } else if (asr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.maghrib;
    } else if (dhuhr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.asr;
    } else if (sunrise.millisecondsSinceEpoch - when <= 0) {
      return Prayer.dhuhr;
    } else if (fajr.millisecondsSinceEpoch - when <= 0) {
      return Prayer.sunrise;
    } else {
      return Prayer.fajr;
    }
  }

  DateTime? timeForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return fajr;
      case Prayer.sunrise:
        return sunrise;
      case Prayer.dhuhr:
        return dhuhr;
      case Prayer.asr:
        return asr;
      case Prayer.maghrib:
        return maghrib;
      case Prayer.isha:
        return isha;
      case Prayer.none:
      default:
        return null;
    }
  }

  static DateTime _seasonAdjustedMorningTwilight(
      double latitude, int day, int year, DateTime sunrise) {
    final a = 75 + ((28.65 / 55.0) * (latitude).abs());
    final b = 75 + ((19.44 / 55.0) * (latitude).abs());
    final c = 75 + ((32.74 / 55.0) * (latitude).abs());
    final d = 75 + ((48.10 / 55.0) * (latitude).abs());

    double adjustment;
    final dyy = PrayerTimes.daysSinceSolstice(day, year, latitude);
    if (dyy < 91) {
      adjustment = a + (b - a) / 91.0 * dyy;
    } else if (dyy < 137) {
      adjustment = b + (c - b) / 46.0 * (dyy - 91);
    } else if (dyy < 183) {
      adjustment = c + (d - c) / 46.0 * (dyy - 137);
    } else if (dyy < 229) {
      adjustment = d + (c - d) / 46.0 * (dyy - 183);
    } else if (dyy < 275) {
      adjustment = c + (b - c) / 46.0 * (dyy - 229);
    } else {
      adjustment = b + (a - b) / 91.0 * (dyy - 275);
    }

    return sunrise.add(Duration(seconds: -(adjustment * 60.0).round()));
  }

  static DateTime _seasonAdjustedEveningTwilight(
      double latitude, int day, int year, DateTime sunset) {
    final a = 75 + ((25.60 / 55.0) * (latitude).abs());
    final b = 75 + ((2.050 / 55.0) * (latitude).abs());
    final c = 75 - ((9.210 / 55.0) * (latitude).abs());
    final d = 75 + ((6.140 / 55.0) * (latitude).abs());

    double adjustment;
    final dyy = PrayerTimes.daysSinceSolstice(day, year, latitude);
    if (dyy < 91) {
      adjustment = a + (b - a) / 91.0 * dyy;
    } else if (dyy < 137) {
      adjustment = b + (c - b) / 46.0 * (dyy - 91);
    } else if (dyy < 183) {
      adjustment = c + (d - c) / 46.0 * (dyy - 137);
    } else if (dyy < 229) {
      adjustment = d + (c - d) / 46.0 * (dyy - 183);
    } else if (dyy < 275) {
      adjustment = c + (b - c) / 46.0 * (dyy - 229);
    } else {
      adjustment = b + (a - b) / 91.0 * (dyy - 275);
    }

    return sunset.add(Duration(seconds: (adjustment * 60.0).round()));
  }

  static int daysSinceSolstice(int dayOfYear, int year, double latitude) {
    int daysSinceSolistice;
    final northernOffset = 10;
    final isLeapYear = CalendarUtil.isLeapYear(year);
    final southernOffset = isLeapYear ? 173 : 172;
    final daysInYear = isLeapYear ? 366 : 365;

    if (latitude >= 0) {
      daysSinceSolistice = dayOfYear + northernOffset;
      if (daysSinceSolistice >= daysInYear) {
        daysSinceSolistice = daysSinceSolistice - daysInYear;
      }
    } else {
      daysSinceSolistice = dayOfYear - southernOffset;
      if (daysSinceSolistice < 0) {
        daysSinceSolistice = daysSinceSolistice + daysInYear;
      }
    }
    return daysSinceSolistice;
  }
}
