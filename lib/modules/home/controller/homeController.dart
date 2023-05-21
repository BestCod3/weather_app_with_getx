import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_with_getx/constants/apiKeys/apiKey.dart';
import 'package:weather_app_with_getx/data/local/weatherData.dart';
import 'package:weather_app_with_getx/modules/home/services/geo_location_service.dart';

class HomeController extends GetxController {
  RxString cityName = ''.obs;
  RxString country = ''.obs;
  RxString tempreture = ''.obs;
  RxString description = ''.obs;
  RxString icon = ''.obs;
  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    showWeatherByLocation();
    super.onInit();
  }

  Future<void> showWeatherByLocation() async {
    // setState(() {
    //   isLoading = true;
    // });
    final position = await GeoLocationService.getPosition();
    await getWeather(position);

    // log("latitude ==> ${position.latitude}");
    // log("longitude ==> ${position.longitude}");
  }

  Future<void> getWeather(Position position) async {
    try {
      final client = http.Client();
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${ApiKeys.MyApiKey}';
      Uri uri = Uri.parse(url);
      final result = await client.get(uri);
      final jsonResult = jsonDecode(result.body);
      cityName.value = jsonResult['name'];

      country.value = jsonResult['sys']['country'];
      final double kelvin = jsonResult['main']['temp'];
      tempreture.value = WeatherData.calculateWeather(kelvin);
      description.value =
          WeatherData.getDescription(num.parse(tempreture.value));
      icon.value = WeatherData.getWeatherIcon(num.parse(tempreture.value));
      // checkDouble(tempereture);
      log('response ===> ${jsonResult['name']}');
      // setState(() {
      //   isLoading = false;
      // });

      // log('response ==> ${result.body}');
      // log('response json ==> ${jsonResult}');
    } catch (e) {
      log('$e');
      throw Exception(e);
    }
  }

  Future<void> getSearchedCityName(dynamic typedCityName) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$typedCityName&appid=${ApiKeys.MyApiKey}');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("data ===> $data");
        cityName.value = data["name"];
        country.value = data['sys']['country'];
        final double kelvin = data['main']['temp'];
        tempreture.value = WeatherData.calculateWeather(kelvin);
        description.value =
            WeatherData.getDescription(num.parse(tempreture.value));
        icon.value = WeatherData.getWeatherIcon(num.parse(tempreture.value));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
