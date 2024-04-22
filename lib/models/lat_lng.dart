class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }
}
