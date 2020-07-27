class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude, {bool validate = false}) {
    if (validate) {
      if (!(latitude.isFinite && latitude.abs() <= 90)) {
        throw ArgumentError(
            'Invalid Latitude supplied, Latitude must be a number between -90 and 90');
      }

      if (!(longitude.isFinite && longitude.abs() <= 180)) {
        throw ArgumentError(
            'Invalid longitude supplied, Longitude must a number between -180 and 180');
      }
    }
  }
}
