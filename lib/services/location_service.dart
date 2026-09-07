import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService();

  /// Checks if current patient position is outside the safe zone radius.
  /// When Firebase is configured, this writes an update to Firestore.
  Future<void> checkGeofence(
    Position currentPosition,
    double homeLat,
    double homeLng,
    double radiusInMeters,
  ) async {
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      homeLat,
      homeLng,
    );

    debugPrint(
      'Geofence check: Distance is ${distance.toStringAsFixed(1)}m (Threshold: ${radiusInMeters.toStringAsFixed(1)}m)',
    );

    if (distance > radiusInMeters) {
      debugPrint(
        'MOCK: Patient is out of zone. Database update bypassed until Firebase is configured.',
      );

      // TODO: Uncomment once Firebase project is configured with web options:
      // await FirebaseFirestore.instance.collection('patients').doc('current_patient').update({
      //   'isOutOfZone': true,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
    }
  }
}
