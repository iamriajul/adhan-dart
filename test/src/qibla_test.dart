import 'package:adhan/adhan.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:test/test.dart';

void main() {
  test('Test Qibla North America', () {
    final washingtonDC = Coordinates(38.9072, -77.0369);
    expect(almostEqualD(Qibla(washingtonDC).direction, 56.560, 0.001), isTrue);

    final nyc = Coordinates(40.7128, -74.0059);
    expect(almostEqualD(Qibla(nyc).direction, 58.481, 0.001), isTrue);

    final sanFrancisco = Coordinates(37.7749, -122.4194);
    expect(almostEqualD(Qibla(sanFrancisco).direction, 18.843, 0.001), isTrue);

    final anchorage = Coordinates(61.2181, -149.9003);
    expect(almostEqualD(Qibla(anchorage).direction, 350.883, 0.001), isTrue);
  });

  test('Test Makkah Coordinates', () {
    expect(almostEqualD(Qibla.MAKKAH.latitude, 21.3891, 0.1), isTrue);
    expect(almostEqualD(Qibla.MAKKAH.longitude, 39.8579, 0.1), isTrue);
  });
}
