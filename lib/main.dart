import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_latest/controller/home_controller.dart';
import 'package:weather_app_latest/views/test.dart';
import 'package:weather_app_latest/views/home_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController());
  runApp(const MyApp());
}

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}


//https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
//5cc6c418446bfebf67471a918348905c
//71318e996c0dc1afbc62f3e104ecc9e8
//4264189987761da8dd6960ab2aa37edd
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '  Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const HomeScreen(),
    );
  }
}

