import 'package:geolocator/geolocator.dart';

/// Thin wrapper around geolocator — requests permission if needed, then
/// reads one fix. Never fabricates a position: any denial/failure just
/// returns null, and callers treat "no location" as "don't filter/show
/// distance for this person" rather than inventing a fallback.
class LocationService {
  LocationService._();

  static Future<Position?> getCurrentPosition() async {
    // Wrapping the whole sequence (not just the final fix) in one timeout:
    // the permission-check calls are themselves unbounded futures, and on
    // some browser/OS combinations they can simply never resolve — without
    // this, a stuck permission check would leave the caller's "Locating…"
    // UI spinning forever with no way out.
    try {
      return await _run().timeout(const Duration(seconds: 20));
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> _run() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }
}
