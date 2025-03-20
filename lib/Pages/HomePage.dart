import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/PulseResultPage.dart';
import 'package:pulse_diagnosis/Pages/QrCodes/QrCode_Get_New_Data.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/MyDrawer.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String number = '';
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login_Page()));
  }

  @override
  void initState() {
    getVisitDataByDate();
  }

  Future<void> getVisitDataByDate() async {
    final _allData = await getVisitDates(globalData.uid);
    if (mounted) {
      setState(() {
        allData = _allData;
      });
    }
  }

  Future<void> logOutConfirmationDialogue(
    BuildContext context,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('サインアウトしますか？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('キャンセル')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('はい', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        signOut();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ログアウトに失敗した。: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    globalData.updateS_Size(MediaQuery.of(context).size);
    return Scaffold(
        appBar: AppBar(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     logOutConfirmationDialogue(context);
        //   },
        //   child: const Icon(Icons.logout),
        // ),
        drawer: Mydrawer(),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Center(
                    child: Text('AI脈診機',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: const Color.fromARGB(255, 211, 162, 57))))),
            SizedBox(
              width: globalData.s_width * 0.5,
              child: Divider(),
            ),
            Text('取得した脈拍データ',
                style: TextStyle(color: Colors.blue, fontSize: 20)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allData.length,
                      itemBuilder: (context, index) {
                        String visitDate = allData[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${(index + 1).toString()}。',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.blue)),
                              TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        });
                                    final visitData = await getVisitData(
                                        globalData.uid, visitDate);
                                      
                                    if (visitData != null) {
                                      await globalData
                                          .updatePulseResult(visitData);
                                    }
                                    console([visitData]);
                                    if (mounted) {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Pulseresultpage()));
                                    }
                                  },
                                  child: Text(
                                    visitDate,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.blue,
                                    ),
                                  ))
                            ],
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ));
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
