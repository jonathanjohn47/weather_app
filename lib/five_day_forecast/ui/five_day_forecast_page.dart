import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_response_model.dart';

import '../get_controllers/five_day_forecast_get_controller.dart';

class FiveDayForecastPage extends StatelessWidget {
  FiveDayForecastPage({super.key});

  FiveDayForecastGetController getController =
      Get.put(FiveDayForecastGetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/5-day-forecast-background.png",
            width: 100.w,
            height: 100.h,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Today, ${getController.forecastModel.value.location.localtime}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.h,
                      )),
                  Obx(() {
                    return Text(
                      getController.forecastModel.value.location.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 3.h,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                  Expanded(
                    child: Obx(() {
                      return !getController.isLoading.value
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return _weatherCard(getController.forecastModel
                                    .value!.forecast.forecastday[index]);
                              },
                              itemCount: getController.forecastModel.value!
                                  .forecast.forecastday.length)
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return _shimmerCard();
                              },
                              itemCount: 5);
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _weatherCard(Forecastday day) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.dp),
          gradient: LinearGradient(
            colors: [
              Color(0xff8ab8c3),
              Color(0xff5788a8),
              Color(0xff5788a8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day.date,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.h,
                )),
            Text(day.day.condition.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.h,
                )),
            SizedBox(height: 1.h),
            Text("${day.day.avgtempC}°",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 5.h,
                )),
            SizedBox(height: 1.h),
            Table(
              border: TableBorder(
                verticalInside: BorderSide(color: Colors.white, width: 0.3.dp),
                top: BorderSide(color: Colors.white, width: 0.3.dp),
              ),
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Column(
                      children: [
                        Text("Humidity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 1.5.h,
                            )),
                        Text("${day.day.avghumidity}%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.h,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Column(
                      children: [
                        Text("Wind",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 1.5.h,
                            )),
                        Text("${day.day.maxwindKph} km/h",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.h,
                            )),
                      ],
                    ),
                  ),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.dp),
          gradient: LinearGradient(
            colors: [
              Color(0xff8ab8c3),
              Color(0xff5788a8),
              Color(0xff5788a8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              /*Color(0xff5788a8),
              Color(0xff5788a8),*/
              baseColor: Color(0xff5788a8),
              highlightColor: Color(0xff8ab8c3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4.dp),
                ),
                child: Text("Today, 2021-10-10",
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 2.h,
                    )),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Color(0xff5788a8),
              highlightColor: Color(0xff8ab8c3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4.dp),
                ),
                child: Text("Sunny",
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 2.h,
                    )),
              ),
            ),
            SizedBox(height: 1.h),
            Shimmer.fromColors(
              baseColor: Color(0xff5788a8),
              highlightColor: Color(0xff8ab8c3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4.dp),
                ),
                child: Text("20°",
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 5.h,
                    )),
              ),
            ),
            SizedBox(height: 1.h),
            Table(
              border: TableBorder(
                verticalInside: BorderSide(color: Colors.white, width: 0.3.dp),
                top: BorderSide(color: Colors.white, width: 0.3.dp),
              ),
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xff5788a8),
                          highlightColor: Color(0xff8ab8c3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4.dp),
                            ),
                            child: Text("Humidity",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 1.5.h,
                                )),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Color(0xff5788a8),
                          highlightColor: Color(0xff8ab8c3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4.dp),
                            ),
                            child: Text("20%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.h,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xff5788a8),
                          highlightColor: Color(0xff8ab8c3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4.dp),
                            ),
                            child: Text("Wind",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 1.5.h,
                                )),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Color(0xff5788a8),
                          highlightColor: Color(0xff8ab8c3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4.dp),
                            ),
                            child: Text("20 km/h",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.h,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
