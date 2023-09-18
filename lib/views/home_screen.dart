import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_latest/controllers/home_controller.dart';
import 'package:weather_app_latest/components/loading_list_page.dart';
import 'package:weather_app_latest/services/internet_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeCC = Get.find();

  String citynameValue = '';

  @override
  void initState() {
    // TODO: implement initState

    homeCC.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeC = Get.find();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFA8BFF),
                  Color(0xff2BD2FF),
                  Color(0xff2BFF88),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Visibility(
              visible: homeC.isLoaded.value,
              replacement: const Center(
                child: LoadingListPage(),
              ),
              child: RefreshIndicator(
                displacement: 250,
                // backgroundColor: Colors.white,
                // color: Colors.green,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1500));
                  log('Test');
                  homeC.getCurrentLocation();
                },
                child: SingleChildScrollView(
                  // physics: const BouncingScrollPhysics(),
                  //physics: const NeverScrollableScrollPhysics(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.09,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.none,
                            onFieldSubmitted: (String s) async {
                              final connectivityResult =
                                  await InternetConnection
                                      .isConnectedToInternet();

                              if (connectivityResult) {
                                // setState(() {
                                homeC.cityname.value = s;
                                homeC.getCityWeather(s);
                                citynameValue = s;
                                homeC.isLoaded.value = false;
                                homeC.controller.clear();
                                // });
                              } else {
                                Get.snackbar(
                                  'Attention!!',
                                  'Please check your internet connection.',
                                  colorText: Colors.red,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                );
                              }
                            },
                            controller: homeC.controller,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search city',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: InkWell(
                                onTap: () async {
                                  // final connectivityResult =
                                  //     await InternetConnection
                                  //         .isConnectedToInternet();
                                  //
                                  // if (connectivityResult) {
                                  try {
                                    homeC.getCityWeather(homeC.cityname.value);
                                    homeC.isLoaded.value = false;
                                    homeC.controller.clear();
                                  } catch (e) {
                                    log('$e');
                                  }
                                  // } else {
                                  //   Get.snackbar(
                                  //     'Attention!!',
                                  //     'Please check your internet connection.',
                                  //     colorText: Colors.red,
                                  //     snackPosition: SnackPosition.BOTTOM,
                                  //     backgroundColor: Colors.white,
                                  //   );
                                  // }
                                },
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 25,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 70,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://openweathermap.org/img/wn/${homeC.iconWather.value}@2x.png"),
                            //whatever image you can put here
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        'Main: ${homeC.iconMain.value}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      homeC.iconDescription.value != ''
                          ? Text(
                              'Description: ${homeC.capitalize(homeC.iconDescription.value)}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: Colors.red,
                              size: 42,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${homeC.cityname.value}, ${homeC.country.value}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Lat: ${homeC.lat.value}, Lon: ${homeC.lon.value}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.10,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: const AssetImage(
                                      'images/thermometer.png'),
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Temperature: ${homeC.temp.value?.toInt()} ºC',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.10,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image:
                                      const AssetImage('images/barometer.png'),
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Pressure: ${homeC.press.value?.toInt()} hPa',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.10,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image:
                                      const AssetImage('images/humidity.png'),
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Humidity: ${homeC.hum.value?.toInt()}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.10,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: const AssetImage(
                                      'images/cloud cover.png'),
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cloud Cover: ${homeC.cover.value?.toInt()}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeCC.controller.dispose();
    super.dispose();
  }
}
