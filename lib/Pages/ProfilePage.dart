import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class Profilepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Profilepage();
}

class _Profilepage extends State<Profilepage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String pass = '';
  String selectedGender = '男';
  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        ageController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

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

  void resetPassword() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentPassword = await getUserPassword(user.uid);
      String newPassword = newPasswordController.text.trim();
      String passwordConfirm = passwordConfirmController.text.trim();
      if (currentPasswordController.text.trim() != currentPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('your current password is not right!')),
        );
        return;
      }
      if (newPassword != passwordConfirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('your new password is not match')),
        );
        return;
      }

      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      Future.delayed(Duration(seconds: 1));
    await EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      // Re-authenticate
      updatePassword(passwordConfirmController.text.trim());
      user.updatePassword(newPasswordController.text.trim());
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'password has changed'.tr(),
            textAlign: TextAlign.center,
          ),
        ));
        setState(() {
          currentPasswordController.text = '';
          newPasswordController.text = '';
          passwordConfirmController.text = '';
        });
      }
    }
  }

  void saveUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
      String name = nameController.text.toString().trim();
      String gender = selectedGender;
      String age = ageController.text.toString().trim();

      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      updateUserData(name, gender, age);
      if (mounted) {
        Navigator.pop(context);
        // showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           content: Text('user info has changed'.tr(), textAlign: TextAlign.center, style: TextStyle(color: const Color.fromARGB(255, 249, 168, 37), fontSize: 20),),
        //         ));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'user info has changed'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(255, 249, 168, 37), fontSize: 20),
          ),
        ));
      }
    }
  }

  Future<void> setInitValue() async {
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
      setState(() {
        selectedGender = globalData.gender;
        nameController.text = globalData.name;
        ageController.text = globalData.age;
      });
    }
  }

  @override
  void initState() {
    setInitValue();
    super.initState();
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
                  Column(children: [
                    const SizedBox(height: 80),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Column(children: [
// =========================================================  Sign Up Title =====================================================

                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "user info".tr(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
// =========================================================  Language Dropdown Button =========================================
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color.fromARGB(
                                        255, 247, 250, 249),
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
                                          value: "en", child: Text("English")),
                                      DropdownMenuItem<String>(
                                          value: "ch", child: Text("中文")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          Form(
                              key: _formKey1,
                              child: Column(
                                children: [
// =========================================================  Email ID  =====================================================

                                  TextFormField(
                                    cursorColor:
                                        const Color.fromARGB(255, 0, 168, 154),
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
                                            dropdownColor: const Color.fromARGB(
                                                255, 247, 250, 249),
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
                                ],
                              )),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 168, 154),
                              backgroundColor:
                                  const Color.fromARGB(255, 247, 250, 249),
                            ),
                            onPressed: () {
                              if (_formKey1.currentState!.validate())
                                saveUser();
                            },
                            child: Center(
                                child: Text("save".tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))),
                          ),
                          const SizedBox(height: 10),
                          Form(
                              key: _formKey2,
                              child: Column(children: [
//========================================================= Current Password  =====================================================
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
                                      icon: const Icon(
                                        Icons.lock_outline_rounded,
                                        color: Colors.grey,
                                      ),
                                      labelText: "current password".tr(),
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
                                  controller: currentPasswordController,
                                ),

//=========================================================  Password  =====================================================
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
                                  controller: newPasswordController,
                                ),

// =========================================================  Password Confirm  =====================================================

                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password cannot be empty".tr();
                                    } else if (value.length <= 5) {
                                      return "Password must be more than 6 characters"
                                          .tr();
                                    }
                                    return null; // Validation passed
                                  },
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
                              ])),
                          const SizedBox(height: 10),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 168, 154),
                              backgroundColor:
                                  const Color.fromARGB(255, 247, 250, 249),
                            ),
                            onPressed: () {
                              if (_formKey2.currentState!.validate())
                                resetPassword();
                            },
                            child: Center(
                                child: Text("password reset".tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))),
                          ),
                          const SizedBox(height: 20),

// =========================================================  SignUp Button =====================================================
                        ]))
                  ])
                ]))));
  }
}
