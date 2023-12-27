import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/five_day_forecast/get_controllers/five_day_forecast_get_controller.dart';

class MockGeolocator extends Mock implements Geolocator {
  @override
  Future<bool> isLocationServiceEnabled() => super.noSuchMethod(
    Invocation.method(#isLocationServiceEnabled, []),
    returnValue: Future.value(true),
    returnValueForMissingStub: Future.value(false),
  );

  @override
  Future<LocationPermission> checkPermission() => super.noSuchMethod(
    Invocation.method(#checkPermission, []),
    returnValue: Future.value(LocationPermission.always),
    returnValueForMissingStub: Future.value(LocationPermission.denied),
  );

  @override
  Future<Position> getCurrentPosition() => super.noSuchMethod(
    Invocation.method(#getCurrentPosition, []),
    returnValue: Future.value(Position(
      latitude: 1.0,
      longitude: 2.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    )),
    returnValueForMissingStub: Future.value(Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    )),
  );

  @override
  Future<Position> getLastKnownPosition(
          {bool forceAndroidLocationManager = false}) =>
      this.noSuchMethod(Invocation.method(#getLastKnownPosition, []));
}

void main() {
  group('_determinePosition', () {
    test(
        'returns position when location services are enabled and permissions are granted',
        () async {
      final geolocator = MockGeolocator();
      final controller = FiveDayForecastGetController();

      when(geolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(geolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.always);
      when(geolocator.getCurrentPosition()).thenAnswer((_) async => Position(
            latitude: 0,
            longitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          ));

      controller.geolocator = geolocator;

      final position = await controller.determinePosition();

      verify(geolocator.isLocationServiceEnabled()).called(1);
      verify(geolocator.checkPermission()).called(1);
      verify(geolocator.getCurrentPosition()).called(1);

      expect(position, isNotNull);
    });
  });
}
