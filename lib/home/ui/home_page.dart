import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather_app/five_day_forecast/ui/five_day_forecast_page.dart';
import 'package:weather_app/models/suggestions_model.dart';
import 'package:weather_app/models/weather_response_model.dart';

import '../get_controllers/home_get_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeGetController getController = Get.put(HomeGetController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/home_background.png",
              height: 100.h,
              width: 100.w,
              fit: BoxFit.fill,
            ),
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: TextFormField(
                    controller: getController.searchController,
                    decoration: InputDecoration(
                      hintText: "Search for Location...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 4.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.location_pin,
                        color: Colors.black,
                      ),
                    ),
                    key: getController.key,
                    onFieldSubmitted: (text) {
                      Get.dialog(Scaffold(
                        body: FutureBuilder<List<SuggestionsModel>>(
                            future: getController.loadSuggestions(
                                getController.searchController.text),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<SuggestionsModel> suggestions =
                                    snapshot.data!;
                                return Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          getController.searchController.text =
                                              suggestions[index].name;
                                          getController
                                              .loadWeatherDataForLocation(
                                                  suggestions[index].lat,
                                                  suggestions[index].lon);
                                          Get.back();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("${suggestions[index].name},",
                                                style: TextStyle(
                                                    fontSize: 4.w,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${suggestions[index].region}, ${suggestions[index].country}",
                                                style:
                                                    TextStyle(fontSize: 3.w)),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: suggestions.length,
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.dp,
                                        indent: 4.w,
                                        endIndent: 4.w,
                                      );
                                    },
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.w),
                  child: Obx(() {
                    return getController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : _weatherCard(
                            getController.weatherResponseModel.value);
                  }),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          icon: Icon(Icons.calendar_today),
          label: Text("5-Day Forecast"),
          onPressed: () {
            Get.to(() => FiveDayForecastPage());
          },
        ),
      ),
    );
  }

  Widget _weatherCard(WeatherResponseModel weatherResponseModel) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: weatherResponseModel.current.isDay == 1
                ? LinearGradient(
                    colors: [
                      Color(0xFF5271ff),
                      Color(0xFF38b6ff),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey.shade700,
                      Colors.grey.shade500,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.w),
              bottomRight: Radius.circular(8.w),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2.dp,
                blurRadius: 2.w,
                offset: Offset(1.w, 1.w),
              ),
            ],
          ),
          width: 80.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Today, ${weatherResponseModel.location.localtime}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 3.w,
                              )),
                          Text(
                            weatherResponseModel.location.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      weatherResponseModel.current.isDay == 1
                          ? Icons.sunny
                          : Icons.nightlight_round,
                      color: Colors.white,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/weather_icon.png",
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "${weatherResponseModel.current.condition.text}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 5.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.w),
                Text(
                  "${weatherResponseModel.current.tempC}°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(children: [
                      Text("Wind",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.w,
                          )),
                      Text("${weatherResponseModel.current.windKph} km/h",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.w,
                          ))
                    ]),
                    TableRow(children: [
                      Text("Pressure",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.w,
                          )),
                      Text("${weatherResponseModel.current.pressureIn}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.w,
                          ))
                    ]),
                    TableRow(children: [
                      Text("Humidity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.w,
                          )),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.dp),
                            child: LinearPercentIndicator(
                              width: 20.w,
                              lineHeight: 1.w,
                              percent:
                                  weatherResponseModel.current.humidity / 100,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              progressColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text("${weatherResponseModel.current.humidity}%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 3.w,
                              ))
                        ],
                      )
                    ]),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
