import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:weather_app/models/weather_response_model.dart';

class FiveDayForecastPage extends StatelessWidget {
  const FiveDayForecastPage({super.key});

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
          ListView.builder(
            itemBuilder: (context, index) {
              return Container();
            },
            itemCount: 5,
          )
        ],
      ),
    );
  }

  Widget _weatherCard(WeatherResponseModel weatherResponseModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      child: Container(
        height: 20.h,
        width: 100.w,
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
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(weatherResponseModel.current.condition.icon)
              ],
            )
          ],
        ),
      ),
    );
  }
}
