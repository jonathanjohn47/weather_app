import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/home/get_controllers/home_get_controller.dart';

import 'mock_geo_locator.dart';

@GenerateMocks([Geolocator])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('flutter.baseflow.com/geolocator')
    .setMockMethodCallHandler((MethodCall methodCall) async {
  switch (methodCall.method) {
    case 'isLocationServiceEnabled':
      return true;
    case 'checkPermission':
      return LocationPermission.always.index;
    case 'getCurrentPosition':
      return {
        'latitude': 1.0,
        'longitude': 2.0,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'accuracy': 0.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speedAccuracy': 0.0,
      };
    default:
      return null;
  }
});
  late MockGeolocator mockGeolocator;
  late HomeGetController homeGetController;

  setUp(() {
    mockGeolocator = MockGeolocator();
    homeGetController = HomeGetController();
    homeGetController.geolocator = mockGeolocator;
  });

  test(
      '_determinePosition() returns a Position when location services are enabled and permissions granted',
      () async {
    // Mock Geolocator responses
    when(mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.always);
    when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async => Position(
          latitude: 1.0,
          longitude: 2.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ));

    // Call the function
    final position = await homeGetController.determinePosition();

    // Verify results
    expect(position, isA<Position>());
    expect(position.latitude, 1.0);
    expect(position.longitude, 2.0);
  });
}
