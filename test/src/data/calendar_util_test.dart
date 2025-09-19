import 'package:adhan/adhan.dart';
import 'package:test/test.dart';

void main() {
  test('Test CalenderUtil.isLeapYear', () {
    expect(CalendarUtil.isLeapYear(2000), isTrue);
    expect(CalendarUtil.isLeapYear(2001), isFalse);
  });

  test('Test CalenderUtil.roundedMinute', () {
    expect(CalendarUtil.roundedMinute(DateTime(2020, 1, 1, 1, 1, 50)),
        DateTime(2020, 1, 1, 1, 2, 0));
    expect(CalendarUtil.roundedMinute(DateTime(2020, 1, 1, 1, 1, 29)),
        DateTime(2020, 1, 1, 1, 1, 0));
  });

  test('Test CalenderUtil.resolveTimeByDateComponents', () {
    expect(CalendarUtil.resolveTimeByDateComponents(DateComponents(2020, 1, 1)),
        DateTime.utc(2020, 1, 1));
  });

  test('Test CalenderUtil.resolveTime', () {
    expect(CalendarUtil.resolveTime(2020, 1, 1), DateTime.utc(2020, 1, 1));
  });
}
