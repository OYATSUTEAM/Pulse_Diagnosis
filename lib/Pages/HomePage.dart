import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/PulseResultPage.dart';
import 'package:pulse_diagnosis/Pages/Pulse_History.dart';
import 'package:pulse_diagnosis/Pages/Results/About_Pulse.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/MyDrawer.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pulse_diagnosis/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String number = '';

  @override
  void initState() {
    getUserUid();
    getVisitDataByDate();
  }

  Future<void> getVisitDataByDate() async {
    while (globalData.uid == 'default') {
      await Future.delayed(Duration(milliseconds: 100));
    }
    final _allData = await getVisitDates(globalData.uid);
    if (mounted) {
      setState(() {
        allData = _allData;
      });
    }
  }

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

  Future<void> getUserUid() async {
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
            userData['birth'],
            userData['phone']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    globalData.updateS_Size(MediaQuery.of(context).size);
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .35,
        ),
        Image.asset('assets/images/login.png',
            width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth)
      ]),
      Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                  child: TextButton(
                child: Text('AI Pulse Diagnosis Machine'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: const Color.fromARGB(255, 211, 162, 57))),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutPulse()));
                },
              ))),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Divider(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
                onPressed: () {},
                child: Row(children: [
                  Text('fetch new data'.tr(),
                      style: TextStyle(color: Color.fromARGB(255, 211, 162, 57))),
                  Icon(Icons.download, color: Color.fromARGB(255, 211, 162, 57))
                ])),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PulseHistory()));
                },
                child: Row(children: [
                  Text('History of previous measurements'.tr(),
                      style: TextStyle(color: Color.fromARGB(255, 211, 162, 57))),
                  Icon(Icons.download, color: Color.fromARGB(255, 211, 162, 57))
                ])),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
                onPressed: () {},
                child: Row(children: [
                  Text('What is a Body Mass Index?'.tr(),
                      style: TextStyle(color: Color.fromARGB(255, 211, 162, 57))),
                  Icon(Icons.download, color: Color.fromARGB(255, 211, 162, 57))
                ])),
          ]),

          // TextButton(
          //   onPressed: () async {
          //     await getVisitDataByDate();
          //   },
          //   child: Text('measurement results'.tr(),
          //       style: TextStyle(color: Color.fromARGB(255, 211, 162, 57), fontSize: 20)),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ListView.builder(
          //           physics: AlwaysScrollableScrollPhysics(),
          //           shrinkWrap: true,
          //           itemCount: allData.length,
          //           itemBuilder: (context, index) {
          //             String visitDate = allData[index];
          //             return ListTile(
          //               title: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text('${(index + 1).toString()}。',
          //                       style:
          //                           TextStyle(fontSize: 22, color: Color.fromARGB(255, 211, 162, 57))),
          //                   TextButton(
          //                       onPressed: () async {
          //                         showDialog(
          //                             context: context,
          //                             barrierDismissible: false,
          //                             builder: (context) {
          //                               return Center(
          //                                   child: CircularProgressIndicator());
          //                             });
          //                         final visitData = await getVisitData(
          //                             globalData.uid, visitDate);

          //                         if (visitData != null) {
          //                           await globalData.updatePulseResult(visitData);
          //                         }
          //                         console([visitData]);
          //                         if (mounted) {
          //                           Navigator.pop(context);
          //                           Navigator.of(context).push(MaterialPageRoute(
          //                               builder: (context) => Pulseresultpage()));
          //                         }
          //                       },
          //                       child: Text(
          //                         visitDate,
          //                         style:
          //                             TextStyle(fontSize: 22, color: Color.fromARGB(255, 211, 162, 57)),
          //                       ))
          //                 ],
          //               ),
          //             );
          //           })
          //     ],
          //   ),
          // )
        ],
      )
    ]));
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("No Mail Apps Found"),
        content: Text("There are no email apps installed on your device."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
