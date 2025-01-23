import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'CreateProfilePage.dart';
import 'LoginPage.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String email = '';
  String pass = '';
  final FlutterLocalization _localization = FlutterLocalization.instance;

  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);

  var id = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

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

  void create_user() {
    if (passwordController.text.trim() ==
        passwordConfirmController.text.trim()) {
      try {
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(id.text.toString().trim())) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter a valid email address.'),
            backgroundColor: const Color.fromARGB(255, 109, 209, 214),
          ));
          return;
        }

        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: id.text.toString().trim(),
                password: passwordController.text.toString().trim())
            .whenComplete(() {
          if (FirebaseAuth.instance.currentUser?.uid != null) {
            sendVerificationEmail();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('登録されたメールアドレスに確認メールが届いています。アカウントを確認し、再度ログインしてください。')));

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SignUpPage();
        }));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("パスワードが一致しない"),
          );
        },
      );
    }
  }

  Future<void> setLanguage(String value) async {
    setState(() {
      selectedLanguage = value;
      _localization.translate(value,
          save: false); // Assuming this is a function you want to trigger.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset('assets/images/login.png'),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  children: [
// =========================================================  Sign Up =======================================================

                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedLanguage == 'ch'
                                ? '注册'
                                : selectedLanguage == 'en'
                                    ? 'SignUp'
                                    : '会員登録',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins'),
                          ),
// =========================================================  Dropdown Button =================================================
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLanguage,
                              onChanged: (value) {
                                setLanguage(value!);
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
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        child: Column(
                      children: [
// =========================================================  Email ID  =====================================================
                        TextFormField(
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.alternate_email_outlined,
                              color: Colors.grey,
                            ),
                            labelText: selectedLanguage == 'ch'
                                ? '电子邮件 ID'
                                : selectedLanguage == 'en'
                                    ? 'Email ID'
                                    : 'メールアドレス',
                          ),
                          controller: id,
                        ),
// =========================================================  Password  =====================================================

                        TextFormField(
                          obscureText: notvisible,
                          decoration: InputDecoration(
                              icon: const Icon(
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
                                      notVisiblePassword = !notVisiblePassword;
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
                              labelText: selectedLanguage == 'ch'
                                  ? '密码确认'
                                  : selectedLanguage == 'en'
                                      ? 'Password Confirm'
                                      : 'パスワードの確認',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      notvisible = !notvisible;
                                      notVisiblePassword = !notVisiblePassword;
                                      passwordVisibility();
                                    });
                                  },
                                  icon: passwordIcon)),
                          controller: passwordConfirmController,
                        )
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
                        create_user();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Center(
                          child: Text(
                        selectedLanguage == 'ch'
                            ? '注册'
                            : selectedLanguage == 'en'
                                ? 'SignUp'
                                : '会員登録',
                        style: TextStyle(fontSize: 15),
                      )),
                    ),

                    const SizedBox(height: 25),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
// =========================================================  Joined us before?  =====================================================

                        Text(
                          selectedLanguage == 'ch'
                              ? '您已经拥有帐户？'
                              : selectedLanguage == 'en'
                                  ? 'Joined us before? '
                                  : 'アカウントありますか？',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
// =========================================================  Login  =====================================================

                        GestureDetector(
                          child: Text(
                            selectedLanguage == 'ch'
                                ? '登录'
                                : selectedLanguage == 'en'
                                    ? 'Login'
                                    : 'ログイン',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginPage();
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
        ));
  }
}
