import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'dart:developer' as developer;

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title, required this.visitDate});
  final String title;
  final String visitDate;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic> visitInfo = {};
  Map<String, dynamic> patient = {};
  String age = '30';
  String gender = '男';
  String pulseExplain = '沈滑有力';
  String visitTime = '2020-1-2';
  String cunResultFreq = '';
  UserData userData = UserData(
      email: '',
      uid: '',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');
//-------------------------    bodyRecognization   -------------------------------

  List healthAssessments0 = [];
  List healthAssessments1 = [];
  List symptoms0 = [];
  List symptoms1 = [];
  String healthAssessments_overview = '';
  List<String> allSymptoms = [];
//-------------------------    bodyRecognization   -------------------------------
  List<Map<String, String>> bodyRecognitions = [];

//-------------------------    principleList   -------------------------------

  List principleList = [];
  List<Map<String, String>> principles = [];

//-------------------------    jingluoListV2   -------------------------------

  List jingluoListV2 = [];

  List<Map<String, String>> jingluoItems = [];

//-------------------------    physiqueList   -------------------------------
  List physiqueList = [];
  String pulseResult = '';
  @override
  void initState() {
    getDate();
    super.initState();
  }

  getDate() async {
    final _pulseResult = await getPulseResult(widget.visitDate);
    UserData? _userData = await getUserData();
    if (_userData != null) {
      setState(() {
        userData = _userData;
      });
    }
    if (mounted) {
      setState(() {});
    }
    if (_pulseResult == null) {
    } else {
      if (mounted) {
        setState(() {
          physiqueList = _pulseResult['physiqueList'];
          patient = _pulseResult['visitInfo']['patient'];
          pulseExplain = _pulseResult['pulseExplain'][0]['name'];
          gender = patient['gender'];
          visitTime = _pulseResult['visitInfo']['visitTime'];
          pulseResult = _pulseResult['visitInfo']['pulseResult'];
          cunResultFreq =
              _pulseResult['visitInfo']['parts'][0]['cunResult']['freq'];
//-------------------------    healthAssessments   -------------------------------

          healthAssessments0 = physiqueList[0]['healthAssessments'];
          healthAssessments_overview = healthAssessments0[0]['overview'];
          symptoms0 = healthAssessments0[0]['symptoms'];

          // Clear previous symptoms
          allSymptoms.clear();

          // Process all physique items
          for (var physique in physiqueList) {
            if (physique['healthAssessments'] != null &&
                physique['healthAssessments'].isNotEmpty) {
              var healthAssessments = physique['healthAssessments'][0];
              if (healthAssessments['symptoms'] != null) {
                for (var symptom in healthAssessments['symptoms']) {
                  if (symptom['rank'] < 4) {
                    allSymptoms.add(symptom['symptom']);
                  }
                }
              }
            }
          }
//-------------------------    bodyRecognization   -------------------------------

          // Process body recognitions dynamically
          bodyRecognitions.clear();
          for (var physique in physiqueList) {
            if (physique['images'] != null && physique['images'].isNotEmpty) {
              bodyRecognitions.add({
                'name': physique['images'][0]['name'],
                'note': physique['note']
              });
            }
          }

//-------------------------    principleList   -------------------------------

          principleList = _pulseResult['principleList'];

          // Process principles dynamically
          principles.clear();
          for (var principle in principleList) {
            if (principle['name'] != null && principle['note'] != null) {
              if (principle['note'] != '') {
                principles.add(
                    {'name': principle['name'], 'note': principle['note']});
              }
            }
          }

//-------------------------    jingluoListV2   -------------------------------
          jingluoListV2 = _pulseResult['jingluoListV2'];
          jingluoItems.clear();
          for (var jingluo in jingluoListV2) {
            if (jingluo['main'] != null && jingluo['mainNote'] != null) {
              if (jingluo['mainNote'] != '') {
                // if (jingluo['rank'] > 3)
                jingluoItems.add(
                    {'name': jingluo['main'], 'note': jingluo['mainNote']});
              }
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TitleWidget(title: widget.title),
          Expanded(
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 170,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  const Color.fromARGB(213, 255, 255, 255),
                              foregroundImage: AssetImage(
                                gender == '男'
                                    ? 'assets/images/man.png'
                                    : 'assets/images/woman.png',
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('氏名： ${patient['name']}'),
                              Text('性別：$gender'),
                              Text('年齢：${userData.age}歳'),
                              Text('位置：左手、右手'),
                              Text('時間：$visitTime'),
                            ],
                          ),
                        ],
                      ),
                      CategoryWidget(title: '総合結果'),
                      Image.asset('assets/images/description.png',
                          width: MediaQuery.of(context).size.width),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        color: Colors.black,
                                      ),
                                      Text('  脈象の説明 :  $pulseResult'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                          'assets/images/earthquake.png',
                                          width: 24),
                                      Text('  脈拍数 :  $cunResultFreq回/分')
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )),
                      CategoryWidget(title: '健康状態'),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'assets/images/body_recognization.png',
                                      width: 20),
                                  Expanded(
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                        TextSpan(
                                            text: '【体質認識】\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        ...bodyRecognitions
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final recognition = entry.value;
                                          return TextSpan(
                                            text:
                                                '${recognition['name']} (${recognition['note']?.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')})${index < bodyRecognitions.length - 1 ? '　、\n' : ''}',
                                          );
                                        }).toList(),
                                      ])))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'assets/images/health_assessment.png',
                                      width: 20),
                                  Expanded(
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                        TextSpan(
                                            text: '【健康評価】\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              '${healthAssessments_overview.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')}\n',
                                        ),
                                        TextSpan(
                                          text: allSymptoms.join('　、'),
                                        ),
                                      ])))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'assets/images/eigth_category.png',
                                      width: 20),
                                  Expanded(
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                        TextSpan(
                                            text: '【八綱弁証】\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        ...principles
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final principle = entry.value;
                                          return TextSpan(
                                            text:
                                                '${principle['name']} (${principle['note']})${index < principles.length - 1 ? '　、\n' : ''}',
                                          );
                                        }).toList(),
                                      ])))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'assets/images/meridian_analysis.png',
                                      width: 20),
                                  Expanded(
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                        TextSpan(
                                            text: '【経絡解析】\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text: '現在、異常が考えられる経絡は次の通りです：\n',
                                        ),
                                        ...jingluoItems
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final jingluo = entry.value;
                                          return TextSpan(
                                            text:
                                                '${jingluo['name']}${jingluo['note']}${index < jingluoItems.length - 1 ? '、\n' : '\n'}',
                                          );
                                        }).toList(),
                                      ])))
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
          )
        ],
      ),
    ));
  }
}
