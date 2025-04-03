import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'package:easy_localization/easy_localization.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String number = '';

  @override
  void initState() {
    getUserUid();
    getVisitDataByDate();
    super.initState();
  }

  Future<void> getVisitDataByDate() async {
    while (globalData.uid == 'default') {
      await Future.delayed(Duration(milliseconds: 100));
    }
    final _allData = await getVisitDates(globalData.uid);
    if (mounted) {
      setState(() {
        allData = _allData;
      });
    }
  }

  signOut() async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login_Page()));
    }
  }

  Future<void> logOutConfirmationDialogue(
    BuildContext context,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Would you like to sign out?'.tr(),
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('yes'.tr(), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        signOut();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${"log out is failed".tr()}: $e')));
      }
    }
  }

  Future<void> getUserUid() async {
    Map<String, dynamic>? userData = await getUserData();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (userData != null) {
        await globalData.updatePatientDetail(
            userData['uid'],
            userData['email'],
            userData['name'],
            userData['address'],
            userData['gender'],
            userData['age'],
            userData['phone']);
      }
    }
  }

  Timer? _timer;
  int _seconds = 0;

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds < 10) {
        _seconds++;
      } else {
        onLongPressComplete(context);
        _timer?.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
    print("Timer stopped");
  }

  @override
  Widget build(BuildContext context) {
    globalData.updateS_Size(MediaQuery.of(context).size);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              signOut();
            },
            child: Icon(Icons.logout)),
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: const Color.fromARGB(255, 247, 250, 249),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.sizeOf(context).height * 0.33,
                child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    )),
              ),
              Expanded(
                      child: Center(
                          child: GestureDetector(
                              onTapDown: (_) {
                                _startTimer();
                              },
                              onTapUp: (_) {
                                _stopTimer();
                              },
                              onTapCancel: () {
                                _stopTimer();
                              },
                              child: Image.asset('assets/images/login.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  fit: BoxFit.fitWidth))))
            ]));
  }
}
