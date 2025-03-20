import 'package:pulse_diagnosis/Pages/Auth/SignIntoPulse.dart';
import 'package:pulse_diagnosis/Pages/Auth/SignUp_Page.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Services/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulse_diagnosis/Services/otp_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/globaldata.dart';

// ignore: camel_case_types
class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_Page();
}

String selectedLanguage = 'ja';

// ignore: camel_case_types
class _Login_Page extends State<Login_Page> {
  // =========================================Declaring are the required variables=============================================
  final _formKey = GlobalKey<FormState>();
  var id = TextEditingController();
  var password = TextEditingController();
  var phone = TextEditingController();
  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);
  bool emailFormVisibility = true;
  bool otpVisibilty = false;
  String? emailError;
  String? _verificationCode;
  String? passError;

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
      ).hasMatch(id.text.toString())) {
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
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id.text.toString(),
        password: password.text.toString(),
      );
    
      isEmailVerified();
        if(mounted){
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        const emailError = 'Enter valid email ID';
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(emailError)));
      }
      if (e.code == 'wrong-password') {
        const passError = 'Enter correct password';
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(passError)));
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are not registed. Sign Up now")),
        );
      }
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("正しいパスワードを入力してください。")));
      }
    }
    setState(() {});
  }
  // =========================================================  Login Using phone number ==============================================

  signinphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.text.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((
          value,
        ) async {
          if (value.user != null) {
            firstLogin();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        console([e]);
        if (e.code == 'invalid-phone-number') {
          const SnackBar(
            content: Text('The provided phone number is not valid.'),
          );
        }
      },
      codeSent: (String? verificationId, int? resendToken) async {
        setState(() {
          otpVisibilty = true;
          _verificationCode = verificationId;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OTPPage(
              id: _verificationCode,
              phone: phone.text.toString(),
            );
          }));
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
    );
  }

  // =========================================================  Login Using Google function ==============================================

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) => {
            if (value.user != null) {firstLogin()},
          },
        );
  }

  // =========================================================  Checking if email is verified =======================================

  void isEmailVerified() {
    
    User user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      firstLogin();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email is not verified.')));
    }
  }

  // =========================================================  Checking First time login ===============================================

  void firstLogin() async {
    Map<String, dynamic>? userData = await getUserData();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (userData != null) {
        // showDialog(
        //     context: context,
        //     builder: (context) => Center(
        //           child: CircularProgressIndicator(),
        //         ));

        await globalData.updatePatientDetail(
            userData['uid'],
            userData['email'],
            userData['name'],
            userData['address'],
            userData['gender'],
            userData['birth'],
            userData['phone']);
        bool isSignin = await isSignIntoPulse(user.uid);
        if (mounted) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return isSignin ? MyHomePage() : SignIn_to_Pulse();
          }));
        }
      }
    } else {}
  }

  //==========================================================  locailization  =====================================================
  setLanguage(String? value) async {
    setState(() {
      selectedLanguage = value!;
    });
    Locale newLocale;
    if (value == 'ja') {
      newLocale = const Locale('ja', 'JP');
    } else if (value == 'en') {
      newLocale = const Locale('en', 'US');
    } else if (value == 'ch') {
      newLocale = const Locale('zh', 'CN');
    } else {
      return;
    }
    await context.setLocale(newLocale);
  }

  @override
  void initState() {
    initLanguage();
    super.initState();
  }

  initLanguage() async {
    setState(() {
      selectedLanguage = 'ja';
    });
  }

  // ================================================Building The Screen ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset('assets/images/login.png'),
                  ),
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
                                  DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          value: selectedLanguage,
                                          onChanged: (value) {
                                            if (value != null) {
                                              setLanguage(value);
                                            }
                                          },
                                          items: [
                                        DropdownMenuItem<String>(
                                            value: "ja", child: Text("日本語")),
                                        DropdownMenuItem<String>(
                                            value: "en",
                                            child: Text("English")),
                                        DropdownMenuItem<String>(
                                            value: "ch", child: Text("中文")),
                                      ]))
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
                                    // suffixIcon: IconButton(
                                    //   onPressed: () {
                                    //     setState(() {
                                    //       emailFormVisibility =
                                    //           !emailFormVisibility;
                                    //     });
                                    //   },
                                    //   icon: const Icon(
                                    //       Icons.phone_android_rounded),
                                    // ),
                                  ),
                                  controller: id,
                                ),

// =========================================================  Password ==============================================
                                TextFormField(
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
                                  controller: password,
                                ),
                              ],
                            ),
                          ),
                        ),

// =========================================================  Phone Number ==============================================
                        Visibility(
                          visible: !emailFormVisibility,
                          child: Form(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'phone number'.tr(),
                                prefixIcon: const Icon(
                                  Icons.phone_android_rounded,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      emailFormVisibility =
                                          !emailFormVisibility;
                                    });
                                  },
                                  icon:
                                      const Icon(Icons.alternate_email_rounded),
                                ),
                              ),
                              controller: phone,
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
                                        color: Colors.indigo,
                                      ),
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
                            horizontal: 6.0,
                            vertical: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (emailFormVisibility) {
                                login();
                                // firstLogin();
                              } else {
                                signinphone();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text('login'.tr(),
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ),

// =========================================================  Login with google ==============================================

                        // Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10.0, vertical: 10),
                        //     child: ElevatedButton.icon(
                        //       onPressed: () {
                        //         signInWithGoogle();
                        //         firstLogin();
                        //       },
                        //       icon: Image.asset(
                        //         'assets/images/google_logo.png',
                        //         width: 20,
                        //         height: 20,
                        //       ),
                        //       style: ElevatedButton.styleFrom(
                        //           minimumSize: const Size.fromHeight(45),
                        //           backgroundColor: Colors.white70,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10))),
                        //       label: Center(
                        //           child: Text(
                        //         selectedLanguage == 'ch'
                        //             ? '使用 Google 登录'
                        //             : selectedLanguage == 'en'
                        //                 ? 'Login with Google'
                        //                 : 'Googleでログイン',
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             color: Colors.black,
                        //             fontFamily: 'Poppins'),
                        //       )),
                        //     )),
                        // Sized box
                        const SizedBox(height: 25),
                        // Register button
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
                                        color: Colors.indigo),
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
