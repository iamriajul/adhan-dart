import 'dart:core' as core;

class ShadowLength {
  final core.double _shadowLength;

  ShadowLength._(this._shadowLength);

  core.double getShadowLength() {
    return _shadowLength;
  }

  static ShadowLength get single => ShadowLength._(1.0);

  static ShadowLength get double => ShadowLength._(2.0);
}
