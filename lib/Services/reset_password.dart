import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RESETpasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RESETpassword();
}

class _RESETpassword extends State<RESETpasswordPage> {
  @override
  var email = TextEditingController();

  resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.text.toString());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextButton(
            onPressed: () {
              if (mounted) Navigator.of(context).pop();
            },
            child: Text("パスワードリセットのURLをメールでお送りしました。"))));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/reset_password.jpg')),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'パスワードを忘れた場合?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ご心配なく！アカウントに関連付けられた住所を入力してください。",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Form(
                    child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email_rounded,
                          color: Colors.grey)),
                )),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Center(
                    child: Text(
                  "リセット",
                  style: TextStyle(fontSize: 15),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
