import 'coordinates.dart';
import 'internal/qibla_util.dart';

class Qibla {
  static final Coordinates MAKKAH = Coordinates(21.4225241, 39.8261818);

  double? _direction;

  double? get direction => _direction;

  /// Calculate Qibla direction degree (Compass/Clockwise)
  ///
  /// [coordinates] a Coordinates instance
  Qibla(Coordinates coordinates) {
    _direction = QiblaUtil.calculateQiblaDirection(coordinates);
  }
}
