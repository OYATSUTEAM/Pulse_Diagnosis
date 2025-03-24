import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/PulseResultPage.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'package:easy_localization/easy_localization.dart';

class PulseHistory extends StatefulWidget {
  const PulseHistory({super.key});

  @override
  State<PulseHistory> createState() => _PulseHistoryState();
}

class _PulseHistoryState extends State<PulseHistory> {
  @override
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

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: const Color.fromARGB(255, 211, 162, 57),
        centerTitle: true,
        title: Text(
          'History of previous measurements'.tr(),
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: Column(
          children: [
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
                                        fontSize: 22, color: Colors.blue),
                                  ))
                            ],
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
