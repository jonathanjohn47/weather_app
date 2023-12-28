import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/forecast_model.dart';

class FiveDayForecastGetController extends GetxController {
  Rx<ForecastModel> forecastModel = ForecastModel.empty().obs;

  RxBool isLoading = false.obs;

  late Geolocator _geolocator;

  set geolocator(Geolocator value) {
    _geolocator = value;
  }

  Geolocator get geolocator => _geolocator;

  @override
  void onInit() {
    loadForecastData();
    super.onInit();
  }

  Future<void> loadForecastData() async {
    try {
      isLoading.value = true;
      await determinePosition().then((position) async {
        var headers = {'accept': 'application/json'};
        var request = http.Request(
            'GET',
            Uri.parse(
                'https://api.weatherapi.com/v1/forecast.json?q=${position.latitude}%2C${position.longitude}&days=5&key=5b276e6121574a8fb2f192325232712&lang=en'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String responseString = await response.stream.bytesToString();
          forecastModel.value = forecastModelFromJson(responseString);
        } else {
          print(response.reasonPhrase);
        }
      });
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      throw e;
    }
  }

  Future<Position> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      throw e;
    }
  }
}
