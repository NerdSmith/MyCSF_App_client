import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mycsf_app_client/home.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ru'),
      ],
      title: 'My SCF',
      theme: _createTheme(),
      home: const Home()
    );
  }
}

ThemeData _createTheme() {
  return ThemeData(
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontSize: 8.0,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontStyle: FontStyle.italic,
          fontSize: 24.0,
        ),
        displayLarge: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
          fontSize: 15.0,
        ),
      )
  );
}
