import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pulse_diagnosis/Services/auth_gate.dart';
// import 'Pages/CreateProfilePage.dart';
// import 'Pages/SignupPage.dart';
import 'firebase_options.dart';
import 'Pages/LoginPage.dart';
// import 'language.dart';
import 'package:flutter_localization/flutter_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterLocalization.instance.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FlutterLocalization _localization = FlutterLocalization.instance;

  page() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return LoginPage();
    } else {
      return const MyHomePage(title: "HomePage");
    }
  }

  // @override
  // void initState() {
  //   _localization.init(
  //     mapLocales: [
  //       const MapLocale(
  //         'en',
  //         AppLocale.EN,
  //         countryCode: 'US',
  //         fontFamily: 'Font EN',
  //       ),
  //       const MapLocale(
  //         'km',
  //         AppLocale.CH,
  //         countryCode: 'CH',
  //         fontFamily: 'Font CH',
  //       ),
  //       const MapLocale(
  //         'ja',
  //         AppLocale.JA,
  //         countryCode: 'JP',
  //         fontFamily: 'Font JA',
  //       ),
  //     ],
  //     initLanguageCode: 'en',
  //   );
  //   _localization.onTranslatedLanguage = _onTranslatedLanguage;
  //   super.initState();
  // }

  // void _onTranslatedLanguage(Locale? locale) {
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // supportedLocales: _localization.supportedLocales,
        // localizationsDelegates: _localization.localizationsDelegates,
        // locale: Locale('ja', 'JP'), // or 'en' for English
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthGate());
  }
}
