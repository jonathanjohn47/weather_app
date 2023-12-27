import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/suggestions_model.dart';
import '../../models/weather_response_model.dart';

class HomeGetController extends GetxController {
  Rx<WeatherResponseModel> weatherResponseModel =
      WeatherResponseModel.empty().obs;

  RxBool isLoading = false.obs;

  GlobalKey<AutoCompleteTextFieldState<SuggestionsModel>> key =
      GlobalKey<AutoCompleteTextFieldState<SuggestionsModel>>();

  RxList<SuggestionsModel> suggestions = RxList<SuggestionsModel>([]);

  TextEditingController searchController = TextEditingController();

  Future<Position> determinePosition() async {
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
  }

  Future<WeatherResponseModel> loadWeatherData() async {
    isLoading.value = true;
    Position position = await determinePosition();

    print("position: ${position.latitude}, ${position.longitude}");
    var headers = {'accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.weatherapi.com/v1/current.json?q=${position.latitude}%2C${position.longitude}&lang=en&key=5b276e6121574a8fb2f192325232712'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      weatherResponseModel.value = weatherResponseModelFromJson(responseString);
      isLoading.value = false;
      return weatherResponseModelFromJson(responseString);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherResponseModel> loadWeatherDataForLocation(
      double lat, double long) async {
    isLoading.value = true;
    var headers = {'accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.weatherapi.com/v1/current.json?q=${lat}%2C${long}&lang=en&key=5b276e6121574a8fb2f192325232712'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      weatherResponseModel.value = weatherResponseModelFromJson(responseString);
      isLoading.value = false;
      return weatherResponseModel.value;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Geolocator geolocator = Geolocator();

  Future<List<SuggestionsModel>> loadSuggestions(String text) async {
    var headers = {'accept': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.weatherapi.com/v1/search.json?q=${text}&key=5b276e6121574a8fb2f192325232712'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return suggestionsModelFromJson(responseString);
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  void onInit() {
    loadWeatherData();
    super.onInit();
  }
}
