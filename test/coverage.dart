import 'src/calculation_method_test.dart' as src_calculation_method_test;
import 'src/calculation_parameters_test.dart'
    as src_calculation_parameters_test;
import 'src/coordinates_test.dart' as src_coordinates_test;
import 'src/data/calendar_util_test.dart' as src_data_calendar_util_test;
import 'src/extensions/datetime_test.dart' as src_extensions_datetime_test;
import 'src/madhab_test.dart' as src_madhab_test;
import 'src/prayer_times_test.dart' as src_prayer_times_test;
import 'src/qibla_test.dart' as src_qibla_test;
import 'src/sunnah_times_test.dart' as src_sunnah_times_test;

void main() {
  src_calculation_method_test.main();
  src_calculation_parameters_test.main();
  src_coordinates_test.main();
  src_data_calendar_util_test.main();
  src_extensions_datetime_test.main();
  src_madhab_test.main();
  src_prayer_times_test.main();
  src_qibla_test.main();
  src_sunnah_times_test.main();
}
