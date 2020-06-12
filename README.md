## Usage

A simple usage example:

```dart
import 'package:adhan/adhan.dart';

main() {
    final kushtia = Coordinates(23.9088, 89.1220);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    final prayerTimes = PrayerTimes(Duration(hours: 6), kushtia, date, params);
  
    print(DateFormat.jm().format(prayerTimes.fajr));
    print(DateFormat.jm().format(prayerTimes.sunrise));
    print(DateFormat.jm().format(prayerTimes.dhuhr));
    print(DateFormat.jm().format(prayerTimes.asr));
    print(DateFormat.jm().format(prayerTimes.maghrib));
    print(DateFormat.jm().format(prayerTimes.isha));
}
```

## TODO
1. add Qibla
2. add SunnahTimes

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/iamriajul/adhan-dart/issues
