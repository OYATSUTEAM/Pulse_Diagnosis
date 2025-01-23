import 'package:pulse_diagnosis/Services/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulse_diagnosis/Services/otp_page.dart';
import 'CreateProfilePage.dart';
import 'SignupPage.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../language.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

String selectedLanguage = 'ch';

class _LoginPage extends State<LoginPage> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

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
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(id.text.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              textAlign: TextAlign.center,
              selectedLanguage == 'ch'
                  ? '请输入有效的电子邮件地址。'
                  : selectedLanguage == 'en'
                      ? 'Please enter a valid email address.'
                      : '有効なメールアドレスを入力してください。'),
          backgroundColor: const Color.fromARGB(255, 109, 209, 214),
        ));
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id.text.toString(), password: password.text.toString());
      isEmailVerified();
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
            const SnackBar(content: Text("You are not registed. Sign Up now")));
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
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            firstLogin();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          const SnackBar(
              content: Text('The provided phone number is not valid.'));
        }
      },
      codeSent: (String? verificationId, int? resendToken) async {
        setState(() {
          otpVisibilty = true;
          _verificationCode = verificationId;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OTPPage(id: _verificationCode, phone: phone.text.toString());
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

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => {
              if (value.user != null) {firstLogin()}
            });
  }

// =========================================================  Checking if email is verified =======================================

  void isEmailVerified() {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      firstLogin();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email is not verified.')));
    }
  }

// =========================================================  Checking First time login ===============================================

  void firstLogin() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      DateTime? creation = user.metadata.creationTime;
      DateTime? lastLogin = user.metadata.lastSignInTime;

      // Check if the account was created and logged in at the same time (first login)
      // if (mounted) {
      if (creation == lastLogin) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CreateProfilePage();
        }));
        // }
      } else {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MyHomePage(title: "Hello");
          }));
        }
      }
    } else {}
  }

//==========================================================  locailization  =====================================================
  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN,
            countryCode: 'US', fontFamily: 'Font EN'),
        const MapLocale('ch', AppLocale.CH,
            countryCode: 'CH', fontFamily: 'Font CH'),
        const MapLocale('ja', AppLocale.JA,
            countryCode: 'JP', fontFamily: 'Font JA'),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    // setState(() {});
  }

  Future<void> setLanguage(String value) async {
    setState(() {
      selectedLanguage = value;
      _localization.translate(value,
          save: false); // Assuming this is a function you want to trigger.
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
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset('assets/images/login.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Column(
                    children: [
// =========================================================  Login Text ==============================================

                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedLanguage == 'ch'
                                  ? '登录'
                                  : selectedLanguage == 'en'
                                      ? 'Login'
                                      : 'ログイン',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedLanguage,
                                // hint: Text(selectedLanguage == 'ch'
                                //     ? '中文'
                                //     : selectedLanguage == 'en'
                                //         ? 'English'
                                //         : '日本語'),
                                onChanged: (value) {
                                  setLanguage(value!);
                                  print(
                                      ' ======================== $value  this is selected value =======================');
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "ch",
                                    child: Text("中文"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "en",
                                    child: Text("English"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "ja",
                                    child: Text("日本語"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sized box
                      const SizedBox(
                        height: 10,
                      ),

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
                                      labelText: selectedLanguage == 'ch'
                                          ? '电子邮件 ID'
                                          : selectedLanguage == 'en'
                                              ? 'Email ID'
                                              : 'メールアドレス',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              emailFormVisibility =
                                                  !emailFormVisibility;
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.phone_android_rounded))),
                                  controller: id,
                                ),

// =========================================================  Password ==============================================

                                TextFormField(
                                    obscureText: notvisible,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          size: 20,
                                          Icons.lock_outline_rounded,
                                          color: Colors.grey,
                                        ),
                                        labelText: selectedLanguage == 'ch'
                                            ? '密码'
                                            : selectedLanguage == 'en'
                                                ? 'Password'
                                                : 'パスワード',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                notvisible = !notvisible;
                                                notVisiblePassword =
                                                    !notVisiblePassword;
                                                passwordVisibility();
                                              });
                                            },
                                            icon: passwordIcon)),
                                    controller: password)
                              ],
                            )),
                      ),
// =========================================================  Phone Number ==============================================

                      Visibility(
                          visible: !emailFormVisibility,
                          child: Form(
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: selectedLanguage == 'ch'
                                        ? '电话号码'
                                        : selectedLanguage == 'en'
                                            ? 'Phone Number'
                                            : '電話番号',
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
                                        icon: const Icon(
                                            Icons.alternate_email_rounded))),
                                controller: phone),
                          )),

                      const SizedBox(height: 13),

// =========================================================  Forgot Password ==============================================

                      const SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Text(
                              selectedLanguage == 'ch'
                                  ? '忘记密码？'
                                  : selectedLanguage == 'en'
                                      ? 'Forgot Password?'
                                      : 'パスワードを忘れた場合?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.indigo),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RESETpasswordPage();
                              }));
                            },
                          ),
                        ),
                      ),

// =========================================================  Login Button ==============================================

                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 10),
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
                                  borderRadius: BorderRadius.circular(10))),
                          child: Center(
                              child: Text(
                            selectedLanguage == 'ch'
                                ? '登录'
                                : selectedLanguage == 'en'
                                    ? 'Longin'
                                    : 'ログイン',
                            style: TextStyle(fontSize: 15),
                          )),
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
                            selectedLanguage == 'ch'
                                ? '您是新用户吗？'
                                : selectedLanguage == 'en'
                                    ? 'Are you new to this app?'
                                    : 'アプリが初めてですか?',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Text(
                              selectedLanguage == 'ch'
                                  ? '注册'
                                  : selectedLanguage == 'en'
                                      ? 'Register'
                                      : '会員登録',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignUpPage();
                              }));
                            },
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
