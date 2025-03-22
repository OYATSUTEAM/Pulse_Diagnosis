import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pulse_diagnosis/Services/auth_gate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ja', 'JP'),
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      saveLocale:false,
      path: 'assets/translations',
      // fallbackLocale: Locale('ja', 'JP'),
      startLocale: const Locale('ja', 'JP'),
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
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
