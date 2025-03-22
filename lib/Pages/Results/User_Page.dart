import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
  @override
  State<UserPage> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<UserPage> {
  Map<String, dynamic> visitInfo = {};
  Map<String, dynamic> patient = {};
  String age = '30';
  String gender = '男';
  String pulseExplain = '沈滑有力';
  String visitTime = '2020-1-2';
  String bodyRecognization = '';
  String healthAssessments = '';
  String principleList = '';
  String jingluoListV2 = '';
  @override
  void initState() {
    getDate();
  }

  int calculateAge(String birthDate) {
    final DateTime birth = DateTime.parse(birthDate);
    final DateTime now = DateTime.now();
    int age = now.year - birth.year;

    // Check if the birthday has occurred this year
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }

    return age;
  }

  getDate() async {
    while (globalData.pulseResult.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (mounted) {
      setState(() {});
    }
    if (globalData.pulseResult.isEmpty) {
      console(['']);
    } else {
      if (mounted) {
        setState(() {
          patient = globalData.pulseResult['visitInfo']['patient'];
          pulseExplain = globalData.pulseResult['pulseExplain'][0]['name'];
          gender = patient['gender'];
          visitTime = globalData.pulseResult['visitInfo']['visitTime'];
          bodyRecognization = globalData.pulseResult['physiqueList'][0]['body'];
          principleList = globalData.pulseResult['principleList'][0]['desc'];
          jingluoListV2 =
              globalData.pulseResult['jingluoListV2'][0]['mainSymptom'];
          healthAssessments = globalData.pulseResult['physiqueList'][0]
              ['healthAssessments'][0]['overview'];
          age = calculateAge(patient['birth']).toString();
          // patient = visitInfo['patient'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    console([patient]);
    return SafeArea(
      child: Column(
        children: [
          TitleWidget(title: widget.title),
          SizedBox(
              height: MediaQuery.of(context).size.height - 150,
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
                            Text('年齢：$age'),
                            Text('位置：左手、右手'),
                            Text('時間：$visitTime'),
                          ],
                        ),
                      ],
                    ),
                    CategoryWidget(title: '総合結果'),
                    Image.asset('assets/images/description.png',
                        width: globalData.s_width),
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
                                    Text('  脈象の説明 :  $pulseExplain'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/images/earthquake.png',
                                      width: 24,
                                    ),
                                    Text('  脈拍数 :  60回/分')
                                  ],
                                )
                              ],
                            ),
                          ],
                        )),
                    CategoryWidget(title: '健康状態'),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
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
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                      TextSpan(
                                          text: '【体質認識】',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${bodyRecognization.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')}',
                                          style: TextStyle()),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                      TextSpan(
                                          text: '【健康評価】',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${healthAssessments.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')}',
                                          style: TextStyle()),
                                    ])))
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/eigth_category.png',
                                    width: 20),
                                Expanded(
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                      TextSpan(
                                          text: '【八綱弁証】',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '$principleList',
                                          style: TextStyle()),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                      TextSpan(
                                          text: '【経絡解析】',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '$jingluoListV2',
                                          style: TextStyle()),
                                    ])))
                              ],
                            ),
                          ],
                        ))),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
