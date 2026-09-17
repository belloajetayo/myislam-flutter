import 'dart:math' as math;

class GeoUtils {
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  /// Calculates the Qibla bearing in degrees (0..360) from true North
  static double calculateQiblaBearing(double lat, double lng) {
    final phiK = kaabaLat * math.pi / 180.0;
    final lambdaK = kaabaLng * math.pi / 180.0;
    final phi = lat * math.pi / 180.0;
    final lambda = lng * math.pi / 180.0;

    final y = math.sin(lambdaK - lambda);
    final x = math.cos(phi) * math.tan(phiK) - math.sin(phi) * math.cos(lambdaK - lambda);

    final bearing = math.atan2(y, x) * 180.0 / math.pi;
    return (bearing + 360.0) % 360.0;
  }

  /// Calculates distance in km between two lat/lng points using Haversine
  static double calculateDistanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0; // Earth radius in km
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLng = (lng2 - lng1) * math.pi / 180.0;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }
}
