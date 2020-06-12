import 'internal/shadow_length.dart';

enum _Madhab {
  /// Shafi Madhab
  shafi,

  /// Hanafi Madhab
  hanafi
}

class Madhab {
  final _Madhab _value;

  @override
  String toString() {
    return _value.toString();
  }

  Madhab._(this._value);

  static Madhab get shafi => Madhab._(_Madhab.shafi);

  static Madhab get hanafi => Madhab._(_Madhab.hanafi);

  ShadowLength getShadowLength() {
    switch (_value) {
      case _Madhab.shafi: {
        return ShadowLength.single;
      }
      case _Madhab.hanafi: {
        return ShadowLength.double;
      }
      default: {
        throw FormatException("Invalid Madhab");
      }
    }
  }
}