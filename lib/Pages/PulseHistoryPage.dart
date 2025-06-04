import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Pages/Results/PulseResultPage.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:easy_localization/easy_localization.dart';

class PulseHistory extends StatefulWidget {
  const PulseHistory({super.key});

  @override
  State<PulseHistory> createState() => _PulseHistoryState();
}

class _PulseHistoryState extends State<PulseHistory> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String number = '';
  UserData userData = UserData(
      email: 'default',
      uid: 'default',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');

  @override
  void initState() {
    _getUserDataFromLocal();
    // getVisitDataByDate();
    super.initState();
  }

  Future<void> _getUserDataFromLocal() async {
    UserData? _userdata = await getUserDataFromLocal();
    setState(() {
      userData = _userdata!;
    });
    getVisitDataByDate();
  }

  Future<void> getVisitDataByDate() async {
    while (userData.uid == 'default') {
      await Future.delayed(Duration(milliseconds: 100));
    }
    final _allData = await getVisitDates(userData.uid);
    if (mounted) {
      setState(() {
        allData = _allData;
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        foregroundColor: const Color.fromARGB(255, 0, 168, 154),
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
                                        builder: (context) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        });
                                    final visitData = await getVisitData(
                                      userData.uid,
                                      visitDate,
                                    );

                                    if (visitData != null) {
                                      await updatePulseResult(
                                        visitData,
                                        // visitDate,
                                      );
                                    }
                                    if (mounted) {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Pulseresultpage(
                                                      visitDate: visitDate)));
                                    }
                                  },
                                  child: Text(
                                    visitDate,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: const Color.fromARGB(
                                            255, 0, 168, 154)),
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
