import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 202, 202, 202),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: const Color.fromARGB(255, 78, 62, 62)),
    labelStyle: TextStyle(color: const Color.fromARGB(255, 210, 33, 33)),
    
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 180, 207, 255)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
  ),
);

final BoxDecoration backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [const Color.fromARGB(255, 3, 84, 151), Color.fromARGB(255, 100, 149, 188)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

final BoxDecoration thermostatContainerDecoration = BoxDecoration(
  color: Colors.white.withOpacity(0.2),
  borderRadius: BorderRadius.circular(100),
);

const TextStyle thermostatTextStyle = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle targetTempTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white70,
);

const Color sliderActiveColor = Colors.white;
const Color sliderInactiveColor = Colors.white54;

const TextStyle loginTitleStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle inputLabelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);
