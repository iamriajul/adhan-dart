import 'package:adhan/adhan.dart';
import 'package:test/test.dart';

void main() {
  test('Test Coordinates Validation', () {
    // Validation On/True
    // Latitude Test
    expect(() => Coordinates(90.7750, -78.6336, validate: true),
        throwsArgumentError);
    expect(() => Coordinates(91.7750, -78.6336, validate: true),
        throwsArgumentError);
    // Longitude Test
    expect(() => Coordinates(89.7750, -180.6336, validate: true),
        throwsArgumentError);
    expect(() => Coordinates(89.7750, -181.6336, validate: true),
        throwsArgumentError);
    // Both Latitude and Longitude
    expect(() => Coordinates(91.7750, -181.6336, validate: true),
        throwsArgumentError);

    // Validation Off/False, It won't throw Error
    // Latitude Test
    expect(
        Coordinates(90.7750, -78.6336, validate: false) is Coordinates, true);
    expect(
        Coordinates(91.7750, -78.6336, validate: false) is Coordinates, true);
    // Longitude Test
    expect(
        Coordinates(89.7750, -180.6336, validate: false) is Coordinates, true);
    expect(
        Coordinates(89.7750, -181.6336, validate: false) is Coordinates, true);
    // Both Latitude and Longitude
    expect(
        Coordinates(91.7750, -181.6336, validate: false) is Coordinates, true);
  });
}
