import 'package:adhan/adhan.dart';
import 'package:test/test.dart';

void main() {
  test('Test CalculationMethod Equality Support', () {
    final karachiMethod1 = CalculationMethod.karachi;
    final karachiMethod2 = CalculationMethod.karachi;
    final egyptianMethod1 = CalculationMethod.egyptian;

    expect(karachiMethod1 == karachiMethod2, isTrue);
    expect(karachiMethod1 == egyptianMethod1, isFalse);

  });
}