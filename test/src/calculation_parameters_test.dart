import 'package:adhan/adhan.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:test/test.dart';

void main() {
  test('Test CalculationParameters.nightPortions', () {
    var parameters;

    parameters = CalculationParameters(fajrAngle: 18, ishaAngle: 18);
    parameters.highLatitudeRule = HighLatitudeRule.middle_of_the_night;
    expect(almostEqualD(parameters.nightPortions().fajr, 0.5, 0.001), isTrue);
    expect(almostEqualD(parameters.nightPortions().isha, 0.5, 0.001), isTrue);

    parameters = CalculationParameters(fajrAngle: 18, ishaAngle: 18);
    parameters.highLatitudeRule = HighLatitudeRule.seventh_of_the_night;
    expect(almostEqualD(parameters.nightPortions().fajr, 1.0 / 7.0, 0.001),
        isTrue);
    expect(almostEqualD(parameters.nightPortions().isha, 1.0 / 7.0, 0.001),
        isTrue);

    parameters = CalculationParameters(fajrAngle: 10.0, ishaAngle: 15.0);
    parameters.highLatitudeRule = HighLatitudeRule.twilight_angle;
    expect(almostEqualD(parameters.nightPortions().fajr, 10.0 / 60.0, 0.001),
        isTrue);
    expect(almostEqualD(parameters.nightPortions().isha, 15.0 / 60.0, 0.001),
        isTrue);
  });
}
