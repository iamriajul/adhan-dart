import 'prayer_times.dart';
import 'data/calendar_util.dart';
import 'data/date_components.dart';

class SunnahTimes {
  /// The midpoint between Maghrib and Fajr
  DateTime _middleOfTheNight;

  DateTime get middleOfTheNight => _middleOfTheNight;

  /// The beginning of the last third of the period between Maghrib and Fajr,
  /// a recommended time to perform Qiyam
  DateTime _lastThirdOfTheNight;

  /// The beginning of the last third of the period between Maghrib and Fajr,
  /// a recommended time to perform Qiyam
  DateTime get lastThirdOfTheNight => _lastThirdOfTheNight;

  SunnahTimes(PrayerTimes prayerTimes) {
    final currentPrayerTimesDate =
        CalendarUtil.resolveTimeByDateComponents(prayerTimes.dateComponents);
    final tomorrowPrayerTimesDate =
        currentPrayerTimesDate.add(Duration(days: 1));
    final tomorrowPrayerTimes = PrayerTimes(
        prayerTimes.coordinates,
        DateComponents.from(tomorrowPrayerTimesDate),
        prayerTimes.calculationParameters);

    final nightDurationInSeconds =
        ((tomorrowPrayerTimes.fajr.millisecondsSinceEpoch -
                prayerTimes.maghrib.millisecondsSinceEpoch) /
            1000) as int;
    _middleOfTheNight = CalendarUtil.roundedMinute(prayerTimes.maghrib
        .add(Duration(seconds: (nightDurationInSeconds / 2.0) as int)));
    _lastThirdOfTheNight = CalendarUtil.roundedMinute(prayerTimes.maghrib
        .add(Duration(seconds: (nightDurationInSeconds * (2.0 / 3.0)) as int)));
  }
}
