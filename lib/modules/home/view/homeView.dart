import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:weather_app_with_getx/modules/home/controller/homeController.dart';

import 'package:weather_app_with_getx/modules/search/view/SearchView.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key});

  final controller = Get.put(HomeController());

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true, //на весь экран
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () async {
              await controller.showWeatherByLocation();
            },
            child: Icon(
              Icons.near_me,
              size: 45,
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                final typedCityName = await Get.to(SearchView());
                await controller.getSearchedCityName(typedCityName);
              },
              child: Icon(
                Icons.location_city,
                size: 45,
              ),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/sea.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
            child: controller.isLoading == true
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 135,
                        child: Text(
                          controller.icon.value,
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 40,
                        child: Obx(
                          () => Text(
                            'Country: ${controller.country.value}',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: 40,
                        child: Obx(
                          () => Text(
                            '${controller.tempreture.value}\u2103',
                            style: TextStyle(fontSize: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 330,
                        left: 120,
                        child: Obx(
                          () => Text(
                            controller.description.value,
                            style: TextStyle(fontSize: 50, color: Colors.white),
                          ),
                        ),
                        //try как приходить информация находит ошибки итд.
                        //initstate до скаффолда
                        //json formatter
                      ),
                      Positioned(
                        top: 530,
                        left: 70,
                        child: Obx(
                          () => Text(
                            controller.cityName.value,
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
