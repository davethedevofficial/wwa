import 'package:flutter/material.dart';
import 'package:wwa/screens/home_screen.dart';
import 'package:wwa/screens/splash_screen.dart';
import 'package:wwa/screens/workout_screen.dart';

import 'helpers/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Workout App',
      theme: ThemeData(
        primarySwatch: primaryMatColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/workout': (context) => WorkoutScreen()
      },
    );
  }
}
