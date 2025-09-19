/// Resolution strategies for handling prayer time calculations in polar regions
/// where the sun may not rise or set for extended periods.
enum PolarCircleResolution {
  /// Find the nearest location (by latitude) where valid sunrise/sunset times can be calculated.
  /// This strategy adjusts the latitude in 0.5° steps toward the equator until valid solar times are found.
  aqrabBalad,

  /// Find the nearest date (forward or backward in time) where valid sunrise/sunset times can be calculated.
  /// This strategy searches for dates when the original location experiences normal day/night cycles.
  aqrabYaum,

  /// Leave prayer times undefined when they cannot be calculated due to polar conditions.
  /// This maintains the original behavior before polar circle resolution was introduced.
  unresolved;
}

/// Constants for polar circle resolution calculations
class _PolarCircleConstants {
  /// Degrees to add/remove at each resolution step for AqrabBalad
  static const double latitudeVariationStep = 0.5;

  /// Latitude threshold for polar circle calculations (65° based on midnight sun research)
  static const double unsafeLatitude = 65.0;

  /// Maximum days to search for AqrabYaum (half a year for practicality)
  static const int maxDaysToSearch = 182;
}

/// Result of polar circle resolution containing resolved calculation data
class _PolarCircleResolutionResult {
  final DateTime date;
  final DateTime tomorrow;
  final Coordinates coordinates;
  final SolarTime solarTime;
  final SolarTime tomorrowSolarTime;

  _PolarCircleResolutionResult({
    required this.date,
    required this.tomorrow,
    required this.coordinates,
    required this.solarTime,
    required this.tomorrowSolarTime,
  });
}

/// Utility functions for polar circle resolution
class _PolarCircleResolutionUtils {
  /// Check if solar time values are valid (not NaN or infinite)
  static bool isValidSolarTime(SolarTime solarTime) {
    bool _valid(double value) => !(value.isInfinite || value.isNaN);
    return _valid(solarTime.sunrise) && _valid(solarTime.sunset);
  }

  /// Check if both current and tomorrow's solar times are valid
  static bool isValidSolarTimePair(SolarTime solarTime, SolarTime tomorrowSolarTime) {
    return isValidSolarTime(solarTime) && isValidSolarTime(tomorrowSolarTime);
  }
}