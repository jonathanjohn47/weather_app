import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/home/get_controllers/home_get_controller.dart';
import 'package:weather_app/models/weather_response_model.dart';


@GenerateMocks([http.Client])
void main() {
  testWidgets('loadWeatherData() returns WeatherResponseModel on successful API response', (WidgetTester tester) async {
    // Bind the TestBindings to provide a mock http.Client
    TestBindings().dependencies();

    HomeGetController controller = Get.put(HomeGetController()); // GetX injects the mock client

    // Mock positions for determinePosition()
    when(controller.determinePosition()).thenAnswer((_) async => Position(latitude: 1.0, longitude: 2.0));

    // Mock HTTP response
    // Create a mock HTTP response with appropriate body and status code
    final mockResponse = http.Response('{"weather_data": "example"}', 200);

// Stub the mocked http.Client's send() method to return the mock response
    when(Get.find<MockClient>().send(any)).thenAnswer((_) async => mockResponse);

    // Call the function
    final weatherData = await controller.loadWeatherData();

    // Verify results
    expect(weatherData, isA<WeatherResponseModel>());
    expect(weatherData, "example"); // Adjust accordingly
    expect(controller.isLoading.value, false);
  });
}

class TestBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => MockClient(), fenix: true);
  }
}
