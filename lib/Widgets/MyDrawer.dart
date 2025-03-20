import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:pulse_diagnosis/Pages/QrCodes/QrCode_Get_New_Data.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'package:easy_localization/easy_localization.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _MydrawerState extends State<Mydrawer> {
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login_Page()));
  }

  Future<void> logOutConfirmationDialogue(
    BuildContext context,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Would you like to sign out?'.tr()),
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${"log out is failed".tr()}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          width: globalData.s_width * 0.4,
          height: globalData.s_height,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrcodeGetNewData()));
                  },
                  child: Text('fetch new data'.tr(), style: TextStyle(fontSize: 24),textAlign: TextAlign.center,)),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              TextButton(
                  onPressed: () {
                    logOutConfirmationDialogue(context);
                  },
                  child: Text('logout'.tr(), style: TextStyle(fontSize: 20),)),
                  Icon(Icons.logout)
              ],
             )
            ],
          ))),
    );
  }
}
