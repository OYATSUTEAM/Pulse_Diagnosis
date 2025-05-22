import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'Login_Page.dart';
// import 'package:open_mail/open_mail.dart';

class SignUp_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUp_Page();
}

class _SignUp_Page extends State<SignUp_Page> {
  String email = '';
  String pass = '';
  String selectedGender = '男';
  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

  void sendVerificationEmail() {
    User user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();
  }

  void createUser() {
    if (passwordController.text.trim() ==
        passwordConfirmController.text.trim()) {
      try {
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(emailController.text.toString().trim())) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Please enter a valid email address.'.tr(),
              textAlign: TextAlign.center,
            ),
            backgroundColor: const Color.fromARGB(255, 39, 38, 37),
          ));
          return;
        }
        if (!RegExp(r'^[0-9]').hasMatch(ageController.text.toString().trim())) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Please enter a valid age.'.tr(),
              textAlign: TextAlign.center,
            ),
            backgroundColor: const Color.fromARGB(255, 39, 38, 37),
          ));
          return;
        }

        try {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text.toString().trim(),
                  password: passwordController.text.toString().trim())
              .whenComplete(() {
            String email = emailController.text.toString().trim();
            String password = passwordController.text.toString().trim();
            if (FirebaseAuth.instance.currentUser?.uid != null) {
              String address = adressController.text.toString().trim();
              String name = nameController.text.toString().trim();
              String gender = selectedGender;
              String phone = phoneController.text.toString().trim();
              String age = ageController.text.toString().trim();
              String uid = FirebaseAuth.instance.currentUser!.uid;
              initUserData(
                  email, uid, name, password, phone, address, gender, age);
              sendVerificationEmail();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.grey[700],
                    duration: Duration(days: 1),
                    content: Column(
                      children: [
                        Text('confirmation email'.tr()),
                      ],
                    )),
              );
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Login_Page();
              }));
            }
          });
        } catch (e) {
          console([e]);
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignUp_Page();
        }));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('The passwords do not match'.tr()));
          });
    }
  }

  setLanguage(String? value) async {
    setState(() {
      selectedLanguage = value!;
    });
    Locale newLocale;
    await globalData.updateCurrentLocal(value!);
    if (value == 'en') {
      newLocale = const Locale('en', 'US');
    } else if (value == 'ja') {
      newLocale = const Locale('ja', 'JP');
    } else if (value == 'ch') {
      newLocale = const Locale('zh', 'CN');
    } else {
      return;
    }

    await context.setLocale(newLocale);
  }

  setGender(String? value) async {
    setState(() {
      selectedGender = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Stack(children: [
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.3,
                      child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            'assets/images/login.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ))),
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Column(
                          children: [
// =========================================================  Sign Up Title =====================================================

                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "register".tr(),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
// =========================================================  Language Dropdown Button =========================================
                                  // DropdownButtonHideUnderline(
                                  //   child: DropdownButton<String>(
                                  //     value: selectedLanguage,
                                  //     onChanged: (value) {
                                  //       if (value != null) {
                                  //         setLanguage(value);
                                  //       }
                                  //     },
                                  //     items: [
                                  //       DropdownMenuItem<String>(
                                  //           value: "ja", child: Text("日本語")),
                                  //       DropdownMenuItem<String>(
                                  //           value: "en",
                                  //           child: Text("English")),
                                  //       DropdownMenuItem<String>(
                                  //           value: "ch", child: Text("中文")),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
// =========================================================  Email ID  =====================================================
                                    TextFormField(
                                      decoration: InputDecoration(
                                          icon: const Icon(
                                            Icons.alternate_email_outlined,
                                            color: Colors.grey,
                                          ),
                                          labelText: "email".tr()),
                                      controller: emailController,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.account_circle,
                                            color: Colors.grey),
                                        labelText: "name".tr(),
                                      ),
                                      controller: nameController,
                                    ),
// =========================================================  Name and Gender  =====================================================
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: TextFormField(
                                            decoration: InputDecoration(
                                                icon: const Icon(
                                                  Icons.apps_outage_outlined,
                                                  color: Colors.grey,
                                                ),
                                                labelText: "age".tr()),
                                            controller: ageController,
                                          )),
// =========================================================  Gender Dropdown Button =================================================

                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedGender,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setGender(value);
                                                }
                                              },
                                              items: [
                                                DropdownMenuItem<String>(
                                                    value: "男",
                                                    child: Text("male".tr())),
                                                DropdownMenuItem<String>(
                                                    value: "女",
                                                    child: Text("female".tr())),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

// =========================================================  Password  =====================================================
                                    TextFormField(
                                      style: TextStyle(
                                          letterSpacing: notvisible ? 2 : 1),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Password cannot be empty"
                                              .tr();
                                        } else if (value.length <= 5) {
                                          return "Password must be more than 6 characters"
                                              .tr();
                                        }
                                        return null; // Validation passed
                                      },
                                      obscureText: notvisible,
                                      decoration: InputDecoration(
                                          icon: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: Colors.grey,
                                          ),
                                          labelText: "password".tr(),
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
                                      controller: passwordController,
                                    ),

// =========================================================  Password Confirm  =====================================================

                                    TextFormField(
                                      style: TextStyle(
                                          letterSpacing: notvisible ? 2 : 1),
                                      obscureText: notvisible,
                                      decoration: InputDecoration(
                                          icon: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: Colors.grey,
                                          ),
                                          labelText: "password confirm".tr(),
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
                                      controller: passwordConfirmController,
                                    ),
                                  ],
                                )),

                            const SizedBox(height: 13),

// =========================================================  SignUp Button =====================================================

                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate())
                                  createUser();
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                  backgroundColor:
                                      const Color.fromARGB(255, 247, 250, 249),
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 168, 154),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Center(
                                  child: Text("register".tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))),
                            ),

                            const SizedBox(height: 25),
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
// =========================================================  Joined us before?  =====================================================

                                Text(
                                  "Join us before?".tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
// =========================================================  Login  =====================================================

                                GestureDetector(
                                  child: Text(
                                    "login".tr(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Login_Page();
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
                ]))));
  }
}
