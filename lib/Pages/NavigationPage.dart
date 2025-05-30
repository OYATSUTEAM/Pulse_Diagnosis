import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/ProfilePage.dart';
import 'package:pulse_diagnosis/Pages/PulseHistoryPage.dart';
import 'package:pulse_diagnosis/Pages/About_Pulse.dart';
import 'package:pulse_diagnosis/Pages/QrCodes/QrCode_For_SignIn.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:easy_localization/easy_localization.dart';

class Navigationpage extends StatefulWidget {
  const Navigationpage({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String number = '';
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MyHomePage(),
    PulseHistory(),
    QrcodeForSignin(),
    AboutPulse(),
    Profilepage(),
  ];
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
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
    _getInitialData();
    // getVisitDataByDate();
    super.initState();
  }

  _getInitialData() async {
    UserData? _userData = await getUserData();
    if (_userData != null) {
      setState(() {
        userData = _userData;
      });
      getVisitDataByDate();
    }
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

  signOut() async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login_Page()));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
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
    return SafeArea(
        child: Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.storage),
                  label: 'history'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.troubleshoot),
                  label: 'fetch pulse'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.question_mark),
                  label: 'body score'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'user info'.tr(),
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              iconSize: 35,
              currentIndex: _selectedIndex, // Keep track of selected index
              selectedItemColor: const Color.fromARGB(255, 0, 168, 154),
              unselectedItemColor: const Color.fromARGB(255, 85, 85, 85),
              unselectedFontSize: 14,
              selectedFontSize: 14,
              showUnselectedLabels: true,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            )));
  }
}
