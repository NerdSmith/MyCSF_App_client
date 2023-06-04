import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:mycsf_app_client/home.dart';
import 'package:mycsf_app_client/onboardings/introduction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool('isIntroShown', false);
  bool isIntroShown = prefs.getBool('isIntroShown') ?? false;

  runApp(MyApp(isIntroShown: isIntroShown));
  _initAppMetrica();
}

Future<void> _initAppMetrica() async {
  await AppMetrica.activate(AppMetricaConfig("ab2df5da-3724-422c-8371-5926813544b1"));
  
}

class MyApp extends StatelessWidget {
  final bool isIntroShown;

  const MyApp({Key? key, required this.isIntroShown}) : super(key: key);

  _setIsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIntroShown', true);
  }

  @override
  Widget build(BuildContext context) {
    if (isIntroShown) {
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
          home: Home()
      );
    }
    else {
      _setIsShown();
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
          home: HomeGateway()
      );
    }
  }
}

class HomeGateway extends StatelessWidget {
  HomeGateway({Key? key}) : super(key: key);
  final List<MyIntroduction> list = [
    MyIntroduction(
      imageUrl: 'assets/onboardings/onboarding1.png',
    ),
    MyIntroduction(
      imageUrl: 'assets/onboardings/onboarding2.png',
    ),
    MyIntroduction(
      imageUrl: 'assets/onboardings/onboarding3.png',
    ),
    MyIntroduction(
      imageUrl: 'assets/onboardings/onboarding4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      backgroudColor: Colors.white,
      foregroundColor: Colors.black,
      skipTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ), //MaterialPageRoute
        );
      },
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
