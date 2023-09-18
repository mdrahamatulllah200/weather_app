import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_latest/constants/constant.dart' as k;
import 'package:weather_app_latest/services/internet_connection.dart';

class HomeController extends GetxController {
  RxBool isLoaded = false.obs;
  Rx temp = 00.0.obs;
  Rx press = 00.obs;
  Rx hum = 00.obs;
  Rx cover = 00.obs;
  RxString cityname = 'Dhaka'.obs;
  RxString iconWather = '01n'.obs;
  Rx iconId = 0.obs;
  RxString country = ''.obs;
  RxString lon = ''.obs;
  RxString lat = ''.obs;
  RxString iconMain = ''.obs;
  RxString iconDescription = ''.obs;

  // bool isLoaded = false;
  //dynamic temp;
  // dynamic press;
  //dynamic hum;
  // dynamic cover;
  // String cityname = '';
  TextEditingController controller = TextEditingController();

  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady

    //selectNewsCheck();
    super.onReady();
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  getCurrentLocation() async {
    final connectivityResult = await InternetConnection.isConnectedToInternet();

    if (connectivityResult) {
      isLoaded.value = true;
      try {
        await Geolocator.requestPermission();
      } catch (e) {}

      LocationPermission permission1 = await Geolocator.checkPermission();
      try {
        if (permission1 == LocationPermission.denied) {
          try {
            Get.snackbar(
              'Attention!!',
              'Location failed!!',
              colorText: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white,
            );
          } catch (e) {}
        }
      } catch (e) {
        log('$e');
      }

      try {
        if (permission1 != LocationPermission.denied) {
          bool isLocationServiceEnabled =
              await Geolocator.isLocationServiceEnabled();
          if (isLocationServiceEnabled == true) {
            var p = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true,
            );
            if (p != null) {
              log('Lat:${p?.latitude}, Long:${p?.longitude}');
              getCurrentCityWeather(p);
              isLoaded.value = true;
            } else {
              log('Data unavailable');
            }
          } else {
            try {
              await Geolocator.requestPermission();
            } catch (e) {
              log('Data unavailable');
            }
          }
        } else {
          try {
            await Geolocator.requestPermission();
          } catch (e) {
            log('Data unavailable');
          }
        }
      } catch (e) {
        log('$e');
      }
    } else {
      Get.snackbar(
        'Attention!!',
        'Please check your internet connection.',
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
    }
  }

  getCityWeather(String citynameValue) async {
    var client = http.Client();
    isLoaded.value = true;
    var uri = '${k.domain}q=$citynameValue&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      isLoaded.value = true;
//      log(data);
      updateUI(decodeData);
      isLoaded.value = true;
    } else {
      isLoaded.value = true;
      temp.value = 0.0;
      press.value = 0;
      hum.value = 0;
      cover.value = 0;
      cityname.value = 'Not available';

      country.value = '';
      lon.value = '';
      lat.value = '';
      iconMain.value = '';
      iconDescription.value = '';

      update();
      log('${response.statusCode}');
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();

    //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&q=London&appid={API key}
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    isLoaded.value = true;
    // var uri =
    //     '${k.domain}q=${cityname.value}&appid=${k.apiKey}';

    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      isLoaded.value = true;
      log(data);
      updateUI(decodeData);
      isLoaded.value = true;
    } else {
      isLoaded.value = true;
      temp.value = 0.0;
      press.value = 0;
      hum.value = 0;
      cover.value = 0;
      cityname.value = 'Not available';

      country.value = '';
      lon.value = '';
      lat.value = '';
      iconMain.value = '';
      iconDescription.value = '';

      update();
      Get.snackbar(
        'Attention!!',
        'Data Request failed!!',
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
      log('${response.statusCode}');
    }
  }

  updateUI(var decodedData) {
    if (decodedData == null) {
      isLoaded.value = true;
      temp.value = 0.0;
      press.value = 0;
      hum.value = 0;
      cover.value = 0;
      cityname.value = 'Not available';

      country.value = '';
      lon.value = '';
      lat.value = '';
      iconMain.value = '';
      iconDescription.value = '';

      update();
    } else {
      temp.value = decodedData['main']['temp'] - 273;
      press.value = decodedData['main']['pressure'];
      hum.value = decodedData['main']['humidity'];
      country.value = decodedData['sys']['country'];
      lon.value = decodedData['coord']['lon'].toString();
      lat.value = decodedData['coord']['lat'].toString();
      if (decodedData['weather'].length == 1) {
        iconWather.value = decodedData['weather'][0]['icon'];
        iconId.value = decodedData['weather'][0]['id'];
        iconMain.value = decodedData['weather'][0]['main'];
        iconDescription.value = decodedData['weather'][0]['description'];
      } else {
        iconWather.value = decodedData['weather'][1]['icon'];
        iconId.value = decodedData['weather'][1]['id'];
        iconMain.value = decodedData['weather'][1]['main'];
        iconDescription.value = decodedData['weather'][1]['description'];
      }

      cover.value = decodedData['clouds']['all'];
      cityname.value = decodedData['name'];
      update();
    }
  }

  /*
  *
  * {
  "coord": {
    "lon": 10.99,
    "lat": 44.34
  },
  "weather": [
    {
      "id": 501,
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "temp_min": 297.56,
    "temp_max": 300.05,
    "pressure": 1015,
    "humidity": 64,
    "sea_level": 1015,
    "grnd_level": 933
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.62,
    "deg": 349,
    "gust": 1.18
  },
  "rain": {
    "1h": 3.16
  },
  "clouds": {
    "all": 100
  },
  "dt": 1661870592,
  "sys": {
    "type": 2,
    "id": 2075663,
    "country": "IT",
    "sunrise": 1661834187,
    "sunset": 1661882248
  },
  "timezone": 7200,
  "id": 3163858,
  "name": "Zocca",
  "cod": 200
}
  *
  * */

  //https://openweathermap.org/img/wn/10d@2x.png
}
