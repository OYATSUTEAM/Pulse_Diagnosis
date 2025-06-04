import 'package:pulse_diagnosis/Pages/Auth/SignUp_Page.dart';
import 'package:pulse_diagnosis/Pages/NavigationPage.dart';
import 'package:pulse_diagnosis/Services/getLocalData.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Pages/Auth/Reset_Password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_Page();
}

String selectedLanguage = '';

// ignore: camel_case_types
class _Login_Page extends State<Login_Page> {
  // =========================================Declaring are the required variables=============================================
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phone = TextEditingController();
  bool notvisible = true;
  bool notVisiblePassword = true;
  bool emailFormVisibility = true;
  bool otpVisibilty = false;
  String? emailError;
  String? passError;
  Icon passwordIcon = const Icon(Icons.visibility);
  UserData userData = UserData(
      email: '',
      uid: '',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');

  @override
  void initState() {
    // initLanguage();
    _getInitailData();

    super.initState();
  }

  _getInitailData() async {
    UserData? _userData = await getUserDataFromLocal();

    if (_userData != null) {
      setState(() {
        userData = _userData;
        emailController.text = _userData.email;
      });
    }
  }

  // =========================================================  Password Visibility function ===========================================

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

  // =========================================================  Login Function ======================================================
  login() async {
    try {
      if (!RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(emailController.text.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            textAlign: TextAlign.center,
            'Please enter a valid email address.'.tr(),
          ),
          backgroundColor: const Color.fromARGB(255, 109, 209, 214),
        ));
        return;
      }
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CircularProgressIndicator(
                  color: const Color.fromARGB(255, 0, 168, 154),
                ),
              ));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      isEmailVerified();
    } on FirebaseAuthException catch (e) {
      console([e, 'this is login error']);
      if (mounted) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
      if (e.code == 'invalid-email') {
        const emailError = 'Enter valid email ID';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(textAlign: TextAlign.center, emailError)));
      }
      if (e.code == 'wrong-password') {
        const passError = 'Enter correct password';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(textAlign: TextAlign.center, passError)));
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  textAlign: TextAlign.center,
                  "You are not registed. Sign Up now")),
        );
      }
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(textAlign: TextAlign.center, "正しいパスワードを入力してください。")));
      }
    }
  }
  // =========================================================  Checking if email is verified =======================================

  void isEmailVerified() {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      final creationTime = user.metadata.creationTime;
      final lastSignInTime = user.metadata.lastSignInTime;
      // =========================================================  Checking First time login ===============================================
      if (creationTime == lastSignInTime) {
        console(['first login']);
        firstLogin();
      } else {
        console(['subsquent login']);
        subsquentLogin();
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Text(
            textAlign: TextAlign.center,
            'Email is not verified.'.tr(),
          )));
    }
  }
  // =========================================================   First time login ===============================================

  void firstLogin() async {
    try {
      UserData? _userData = await getUserDataFromLocal();
      if (_userData == null) return;

      await initUserDataToFirebase(_userData);

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Navigationpage(selectedIndex: 0);
        }));
      }
    } catch (e) {
      console([e]);
    }
  }
  // =========================================================  SubSquent time login ===============================================

  void subsquentLogin() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final pulseData = await getPulseDataFromFirebase(user.uid);
      if (pulseData != null) {
        await savePulseDataToLocal(pulseData);
      }
      // getUserDataFromFirebase();
      updatePasswordInFirebase(passwordController.text);
      if (mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Navigationpage(selectedIndex: 0);
        }));
      }
    } catch (e) {
      print('Error fetching pulse data: $e');
    }
  }
  //==========================================================  locailization  =====================================================
  // setLanguage(String? value) async {
  //   setState(() {
  //     selectedLanguage = globalData.currentLocal;
  //   });
  //   globalData.updateCurrentLocal(value!);
  //   Locale newLocale;
  //   if (value == 'ja') {
  //     newLocale = const Locale('ja', 'JP');
  //   } else if (value == 'en') {
  //     newLocale = const Locale('en', 'US');
  //   } else if (value == 'ch') {
  //     newLocale = const Locale('zh', 'CN');
  //   } else {
  //     return;
  //   }
  //   await context.setLocale(newLocale);
  // }

  initLanguage() async {
    setState(() {
      // selectedLanguage = globalData.currentLocal;
    });
  }

  // Function to get pulse data from Firebase
  Future<Map<String, dynamic>?> getPulseDataFromFirebase(String userId) async {
    try {
      final pulseDoc = await FirebaseFirestore.instance
          .collection('pulse_data')
          .doc(userId)
          .get();

      if (pulseDoc.exists) {
        return pulseDoc.data();
      }
      return null;
    } catch (e) {
      print('Error getting pulse data: $e');
      return null;
    }
  }

  // Function to save pulse data to local storage
  Future<void> savePulseDataToLocal(Map<String, dynamic> pulseData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pulse_data', jsonEncode(pulseData));
    } catch (e) {
      print('Error saving pulse data: $e');
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

  // ================================================Building The Screen ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 40),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
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
                            width: MediaQuery.of(context).size.width * 0.5),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      child: Column(children: [
// =========================================================  Login Text ==============================================
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'login'.tr(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins'),
                                  ),
                                  // DropdownButtonHideUnderline(
                                  //     child: DropdownButton<String>(
                                  //         value: selectedLanguage,
                                  //         onChanged: (value) {
                                  //           if (value != null) {
                                  //             setLanguage(value);
                                  //           }
                                  //         },
                                  //         items: [
                                  //       DropdownMenuItem<String>(
                                  //           value: "ja", child: Text("日本語")),
                                  //       DropdownMenuItem<String>(
                                  //           value: "en",
                                  //           child: Text("English")),
                                  //       DropdownMenuItem<String>(
                                  //           value: "ch", child: Text("中文")),
                                  //     ]))
                                ])),

                        const SizedBox(height: 10),

                        Visibility(
                          visible: emailFormVisibility,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
// =========================================================  Email ID ==============================================
                                TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      size: 20,
                                      Icons.alternate_email_outlined,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'email'.tr(),
                                  ),
                                  controller: emailController,
                                ),

// =========================================================  Password ==============================================
                                TextFormField(
                                  style: TextStyle(
                                      letterSpacing: notvisible ? 2 : 1),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password cannot be empty".tr();
                                    } else if (value.length <= 5) {
                                      return "Password must be more than 6 characters"
                                          .tr();
                                    }
                                    return null;
                                  },
                                  obscureText: notvisible,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        size: 20,
                                        Icons.lock_outline_rounded,
                                        color: Colors.grey),
                                    labelText: 'password'.tr(),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          notvisible = !notvisible;
                                          notVisiblePassword =
                                              !notVisiblePassword;
                                          passwordVisibility();
                                        });
                                      },
                                      icon: passwordIcon,
                                    ),
                                  ),
                                  controller: passwordController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),

// =========================================================  Forgot Password ==============================================
                        const SizedBox(height: 15),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.0),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    child: Text(
                                      'forgot password'.tr(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue),
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RESETpasswordPage();
                                      }));
                                    }))),

// =========================================================  Login Button ==============================================
                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 247, 250, 249),
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 168, 154),
                              minimumSize: const Size.fromHeight(45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text('login'.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text(
                                'are you new to this app'.tr(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                  child: Text(
                                    'register'.tr(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SignUp_Page();
                                    }));
                                  })
                            ]))
                      ]))
                ]))));
  }
}
