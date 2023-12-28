import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/home/get_controllers/home_get_controller.dart';
import 'package:weather_app/models/suggestions_model.dart';
import 'package:weather_app/models/weather_response_model.dart';

void main() {
  group('checkifapicallsreturnproperdata', () {
    test(
        'returns a WeatherResponseModel if the http call completes successfully',
        () async {
      final homeGetController = HomeGetController();

      var result =
          await homeGetController.loadWeatherDataForLocation(51.5074, 0.1278);

      expect(result, isA<WeatherResponseModel>());
    });
    test(
        'returns a List<SuggestionsModel> if the http call completes successfully',
        () async {
      final homeGetController = HomeGetController();

      var result = await homeGetController.loadSuggestions("London");

      expect(result, isA<List<SuggestionsModel>>());
    });
  });
}
