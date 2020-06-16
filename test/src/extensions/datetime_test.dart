import 'package:adhan/src/extensions/datetime.dart';
import 'package:test/test.dart';

void main() {
  test('Test dayOfYear with DateTime', () {
    final myDate = DateTime(2020, 3, 2, 14, 30);
    // in 2020
    // January has 31 days
    // February has 29 Days
    // March has 31 Days
    // so 31 + 29 and + 2 = 62
    expect(myDate.dayOfYear, 62);
  });

  test('Test copyWith with DateTime', () {
    final myDate = DateTime(2020, 1, 1, 1, 1, 1, 1, 1);
    final myDateCopied = myDate.copyWith(minute: 5, second: 5);

    final myDateUtcCopied = myDate.toUtc().copyWith(minute: 5, second: 5);

    expect(myDateCopied, DateTime(2020, 1, 1, 1, 5, 5, 1, 1));
    expect(myDateCopied.isUtc, isFalse);

    expect(myDateUtcCopied.isUtc, isTrue);

    expect(myDate.copyWith(), DateTime(2020, 1, 1, 1, 1, 1, 1, 1));
    expect(
        myDate.toUtc().copyWith(), DateTime(2020, 1, 1, 1, 1, 1, 1, 1).toUtc());
  });
}
