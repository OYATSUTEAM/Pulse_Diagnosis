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
      saveLocale: false,
      path: 'assets/translations',
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
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: const Color.fromARGB(255, 0, 168, 154),
            cursorColor: const Color.fromARGB(255, 0, 168, 154),
            selectionHandleColor: const Color.fromARGB(255, 0, 168, 154),
          ),
          indicatorColor: const Color.fromARGB(255, 0, 168, 154),
          primaryColor: const Color.fromARGB(255, 0, 168, 154),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey), // Hint text color
              labelStyle:
                  TextStyle(color: const Color.fromARGB(255, 75, 75, 75)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 139, 139, 139),
                ), // Border color when enabled
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: const Color.fromARGB(255, 0, 168, 154),
              ))),
          elevatedButtonTheme: ElevatedButtonThemeData(),
          textTheme: TextTheme(),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'NotoSansJP',
          appBarTheme: AppBarTheme(color: Colors.white),
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          snackBarTheme: SnackBarThemeData(
              contentTextStyle:
                  TextStyle(color: const Color.fromARGB(255, 249, 168, 37)),
              actionTextColor: const Color.fromARGB(255, 249, 168, 37),
              closeIconColor: Colors.black,
              backgroundColor: Colors.white),
          drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: const Color.fromARGB(255, 0, 168, 154),
            backgroundColor: const Color.fromARGB(255, 247, 250, 249),
          )),
      home: AuthGate(),
    );
  }
}
