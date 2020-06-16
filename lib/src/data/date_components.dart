class DateComponents {
  final int year;
  final int month;
  final int day;

  @override
  bool operator ==(other) {
    return other is DateComponents &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  DateComponents(this.year, this.month, this.day);

  /// Convenience method that returns a [DateComponents] from a given [DateTime]
  ///
  /// [date] the date
  /// return the [DateComponents] (according to the default device timezone)
  static DateComponents from(DateTime date) {
    return DateComponents(date.year, date.month, date.day);
  }
}
