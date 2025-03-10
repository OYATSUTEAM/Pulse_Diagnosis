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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await EasyLocalization.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('ja', 'JP'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String corruptedPathPDF = "";
  @override
  void initState() {
    super.initState();

    // fetchPDFFiles();
  }

  Future<void> fetchPDFFiles() async {
    try {
      final fetchedPdfFiles = await getPdfList();
      setState(() {
        globalData.pdfFiles = fetchedPdfFiles;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: AuthGate(),
    );
  }
}
