import 'data/date_components.dart';
import 'internal/solar_time.dart';
import 'polar_circle_resolution.dart';
import 'coordinates.dart';

/// Implementation of AqrabBalad resolution strategy
/// Finds the nearest location (by latitude) where valid sunrise/sunset times can be calculated
class _AqrabBaladResolver {
  static PolarCircleResolutionResult? resolve(
    Coordinates originalCoordinates,
    DateTime date,
    double latitude,
  ) {
    // Calculate solar times at the given latitude
    final coordinates = Coordinates(latitude, originalCoordinates.longitude);
    final solarTime = SolarTime(date, coordinates);
    final tomorrow = date.add(Duration(days: 1));
    final tomorrowSolarTime = SolarTime(tomorrow, coordinates);

    // If solar times are invalid and we're still in polar region
    if (!PolarCircleResolutionUtils.isValidSolarTimePair(solarTime, tomorrowSolarTime)) {
      // Check if we've reached a safe latitude
      if (latitude.abs() >= PolarCircleConstants.unsafeLatitude) {
        // Recursively try 0.5° closer to equator
        final newLatitude = latitude - (latitude >= 0 ? 1 : -1) * PolarCircleConstants.latitudeVariationStep;
        return resolve(originalCoordinates, date, newLatitude);
      } else {
        // Reached safe latitude but still no valid solar times
        return null;
      }
    }

    // Return resolved values
    return PolarCircleResolutionResult(
      date: date,
      tomorrow: tomorrow,
      coordinates: coordinates,
      solarTime: solarTime,
      tomorrowSolarTime: tomorrowSolarTime,
    );
  }
}

/// Implementation of AqrabYaum resolution strategy
/// Finds the nearest date (forward or backward in time) where valid sunrise/sunset times can be calculated
class _AqrabYaumResolver {
  static PolarCircleResolutionResult? resolve(
    Coordinates coordinates,
    DateTime originalDate,
    int daysAdded,
    int direction,
  ) {
    // Safety check: don't search more than half a year
    if (daysAdded > PolarCircleConstants.maxDaysToSearch) {
      return null;
    }

    // Try calculating for offset date
    final testDate = originalDate.add(Duration(days: direction * daysAdded));
    final tomorrow = testDate.add(Duration(days: 1));
    final solarTime = SolarTime(testDate, coordinates);
    final tomorrowSolarTime = SolarTime(tomorrow, coordinates);

    // If still invalid, reverse direction and continue searching
    if (!PolarCircleResolutionUtils.isValidSolarTimePair(solarTime, tomorrowSolarTime)) {
      // Determine next search parameters
      final nextDaysAdded = daysAdded + (direction > 0 ? 0 : 1);
      final nextDirection = -direction;

      return resolve(coordinates, originalDate, nextDaysAdded, nextDirection);
    }

    // Return resolved values (using original date for consistency, but resolved solar times)
    return PolarCircleResolutionResult(
      date: originalDate, // Keep original date for prayer time calculation
      tomorrow: originalDate.add(Duration(days: 1)),
      coordinates: coordinates,
      solarTime: solarTime,
      tomorrowSolarTime: tomorrowSolarTime,
    );
  }
}

/// Main resolver that dispatches to the appropriate strategy
class PolarCircleResolver {
  static PolarCircleResolutionResult? resolve(
    PolarCircleResolution strategy,
    Coordinates coordinates,
    DateTime date,
  ) {
    switch (strategy) {
      case PolarCircleResolution.aqrabBalad:
        return _AqrabBaladResolver.resolve(coordinates, date, coordinates.latitude);

      case PolarCircleResolution.aqrabYaum:
        return _AqrabYaumResolver.resolve(coordinates, date, 1, 1);

      case PolarCircleResolution.unresolved:
        return null;
    }
  }
}