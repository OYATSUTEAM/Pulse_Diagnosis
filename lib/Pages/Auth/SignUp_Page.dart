import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'Login_Page.dart';
import 'package:open_mail/open_mail.dart';

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
  final TextEditingController dateController = TextEditingController();
  final TextEditingController adressController = TextEditingController();

  DateTime? _selectedDate = DateTime(1990, 1, 1);
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Format date
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

  void createUser() {
    if (passwordController.text.trim() ==
        passwordConfirmController.text.trim()) {
      try {
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(emailController.text.toString().trim())) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter a valid email address.'.tr()),
            backgroundColor: const Color.fromARGB(255, 109, 209, 214),
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
              String birth = dateController.text.toString().trim();
              String uid = FirebaseAuth.instance.currentUser!.uid;
              initUserData(
                  email, uid, name, password, phone, address, gender, birth);
              sendVerificationEmail();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    duration: Duration(days: 1),
                    content: Column(
                      children: [
                        Text('confirmation email'.tr()),
                        TextButton(
                            onPressed: () async {
                              try {
                                var result = await OpenMail.openMailApp();
                              } catch (e) {
                                throw Exception('Could not launch $e');
                              }
                            },
                            child: Text('click here to open your email'.tr()))
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
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: Colors.white,
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(children: [
              Positioned(
                  top: MediaQuery.of(context).size.width * 0.5,
                  child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/images/login.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ))),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: Column(
                      children: [
// =========================================================  Sign Up Title =====================================================

                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "register".tr(),
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins'),
                              ),
// =========================================================  Language Dropdown Button =========================================
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
                                        value: "ch", child: Text("中文")),
                                    DropdownMenuItem<String>(
                                        value: "en", child: Text("English")),
                                    DropdownMenuItem<String>(
                                        value: "ja", child: Text("日本語")),
                                  ],
                                ),
                              ),
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
                                          icon: const Icon(Icons.account_circle,
                                              color: Colors.grey),
                                          labelText: "name".tr(),
                                        ),
                                        controller: nameController,
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

                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: const Icon(
                                      Icons.smartphone,
                                      color: Colors.grey,
                                    ),
                                    labelText: "phone number".tr(),
                                  ),
                                  controller: phoneController,
                                ),

// =========================================================  Password  =====================================================
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password cannot be empty".tr();
                                    } else if (value.length <= 5) {
                                      return "Password must be more than 6 characters".tr();
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

                                TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.calendar_today,
                                        color: Colors.grey),
                                    labelText: "Select Date".tr(),
                                  ),
                                  readOnly:
                                      true, // Prevent keyboard from showing
                                  onTap: () => _selectDate(
                                      context), // Show date picker on tap
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.home_outlined,
                                        color: Colors.grey),
                                    labelText: "address".tr(),
                                  ),
                                  controller: adressController,
                                ),
                              ],
                            )),

                        const SizedBox(height: 13),
// =============================================  By signing up, you agree to our Terms & conditions and Privacy Policy ===========================================

                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 20.0),
                        //   child: Align(
                        //     child: Text(
                        //         textAlign: TextAlign.center,
                        //         selectedLanguage == 'ch'
                        //             ? '注册即表示您同意我们的条款和条件以及隐私政策'
                        //             : selectedLanguage == 'en'
                        //                 ? 'By signing up, you agree to our Terms &  Privacy Policy'
                        //                 : 'サインアップすると、利用規約と\nプライバシーポリシーに\n同意したことになります。',
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w500,
                        //             color: Colors.grey),
                        //         softWrap: true),
                        //   ),
                        // ),
// =========================================================  SignUp Button =====================================================

                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) createUser();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Center(
                              child: Text("register".tr(),
                                  style: TextStyle(fontSize: 15))),
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
                                    color: Colors.indigo),
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
            ])));
  }
}
