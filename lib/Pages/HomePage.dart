import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
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
  UserData userData = UserData(
      email: 'default',
      uid: '',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');
  @override
  void initState() {
    _getInitialData();
    // getVisitDataByDate();
    super.initState();
  }

  Future<void> getVisitDataByDate() async {
    while (userData.uid == 'default') {
      await Future.delayed(Duration(milliseconds: 100));
    }
    final _allData = await getVisitDates(userData.uid);
    if (mounted) {
      setState(() {
        allData = _allData;
      });
    }
  }

  _getInitialData() async {
    UserData? _userdata = await getUserData();
    if (_userdata != null) {
      setState(() {
        userData = _userdata;
      });
    }
    getVisitDataByDate();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                width: size.width,
                height: size.height * 0.33,
                child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: size.width * 0.5,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    )),
              ),
              Expanded(
                  child: Center(
                      child: Image.asset(
                'assets/images/login.png',
                width: size.width * 0.7,
                fit: BoxFit.fitWidth,
              )))
            ]));
  }
}
