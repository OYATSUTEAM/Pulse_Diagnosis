import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
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
//-------------------------    bodyRecognization   -------------------------------

  List healthAssessments0 = [];
  List healthAssessments1 = [];
  List symptoms0 = [];
  List symptoms1 = [];
  String healthAssessments_overview = '';
  String symptom0 = '';
  String symptom1 = '';
  String symptom2 = '';
  String symptom3 = '';
  String symptom4 = '';
  String symptom5 = '';
//-------------------------    bodyRecognization   -------------------------------
  String bodyRecognization0_name = '';
  String bodyRecognization0_note = '';
  String bodyRecognization1_name = '';
  String bodyRecognization1_note = '';

//-------------------------    principleList   -------------------------------

  List principleList = [];
  String principleList0_name = '';
  String principleList1_name = '';
  String principleList2_name = '';
  String principleList3_name = '';
  String principleList0_note = '';
  String principleList1_note = '';
  String principleList2_note = '';
  String principleList3_note = '';

//-------------------------    jingluoListV2   -------------------------------

  List jingluoListV2 = [];
  String jingluoListV0_name = '';
  String jingluoListV1_name = '';
  String jingluoListV2_name = '';
  String jingluoListV3_name = '';
  String jingluoListV4_name = '';
  String jingluoListV0_note = '';
  String jingluoListV1_note = '';
  String jingluoListV2_note = '';
  String jingluoListV3_note = '';
  String jingluoListV4_note = '';

//-------------------------    physiqueList   -------------------------------
  List physiqueList = [];
  String pulseResult = '';
  @override
  void initState() {
    getDate();
    super.initState();
  }

  getDate() async {
    while (globalData.pulseResult.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (mounted) {
      setState(() {});
    }
    if (globalData.pulseResult.isEmpty) {
    } else {
      if (mounted) {
        setState(() {
          physiqueList = globalData.pulseResult['physiqueList'];
          patient = globalData.pulseResult['visitInfo']['patient'];
          pulseExplain = globalData.pulseResult['pulseExplain'][0]['name'];
          gender = patient['gender'];
          visitTime = globalData.pulseResult['visitInfo']['visitTime'];
          pulseResult = globalData.pulseResult['visitInfo']['pulseResult'];
          cunResultFreq = globalData.pulseResult['visitInfo']['parts'][0]
              ['cunResult']['freq'];
//-------------------------    healthAssessments   -------------------------------

          healthAssessments0 = physiqueList[0]['healthAssessments'];
          healthAssessments1 = physiqueList[1]['healthAssessments'];
          healthAssessments_overview = healthAssessments0[0]['overview'];
          symptoms0 = healthAssessments0[0]['symptoms'];
          symptoms1 = healthAssessments1[0]['symptoms'];
          symptom0 = symptoms0[0]['symptom'];
          symptom1 = symptoms0[1]['symptom'];
          symptom2 = symptoms0[2]['symptom'];
          symptom3 = symptoms1[0]['symptom'];
          symptom4 = symptoms1[1]['symptom'];
          symptom5 = symptoms1[2]['symptom'];
//-------------------------    bodyRecognization   -------------------------------

          bodyRecognization0_name = physiqueList[0]['images'][0]['name'];
          bodyRecognization1_name = physiqueList[1]['images'][0]['name'];
          bodyRecognization0_note = physiqueList[0]['note'];
          bodyRecognization1_note = physiqueList[1]['note'];

//-------------------------    principleList   -------------------------------

          principleList = globalData.pulseResult['principleList'];
          principleList0_name = principleList[0]['name'];
          principleList1_name = principleList[1]['name'];
          principleList2_name = principleList[2]['name'];
          principleList3_name = principleList[3]['name'];

          principleList0_note = principleList[0]['note'];
          principleList1_note = principleList[1]['note'];
          principleList2_note = principleList[2]['note'];
          principleList3_note = principleList[3]['note'];

//-------------------------    jingluoListV2   -------------------------------
          jingluoListV2 = globalData.pulseResult['jingluoListV2'];
          jingluoListV0_name = jingluoListV2[0]['main'];
          jingluoListV1_name = jingluoListV2[1]['main'];
          jingluoListV2_name = jingluoListV2[2]['main'];
          jingluoListV3_name = jingluoListV2[3]['main'];
          jingluoListV4_name = jingluoListV2[4]['main'];
          jingluoListV0_note = jingluoListV2[0]['mainNote'];
          jingluoListV1_note = jingluoListV2[1]['mainNote'];
          jingluoListV2_note = jingluoListV2[2]['mainNote'];
          jingluoListV3_note = jingluoListV2[3]['mainNote'];
          jingluoListV4_note = jingluoListV2[4]['mainNote'];

          age = globalData.age;
          // patient = visitInfo['patient'];
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
                              Text('年齢：$age歳'),
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
                                        TextSpan(
                                          text:
                                              '$bodyRecognization0_name (${bodyRecognization0_note.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')})　、\n',
                                        ),
                                        TextSpan(
                                          text:
                                              '$bodyRecognization1_name (${bodyRecognization1_note.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n').replaceAll('<br/>', '')})',
                                        ),
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
                                          text:
                                              '$symptom0　、$symptom1　、$symptom2　、$symptom3　、$symptom4　、$symptom5　',
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
                                        principleList0_note != ''
                                            ? TextSpan(
                                                text:
                                                    '$principleList0_name ($principleList0_note)　',
                                              )
                                            : TextSpan(),
                                        principleList1_note != ''
                                            ? TextSpan(
                                                text:
                                                    '、\n$principleList1_name ($principleList1_note)　',
                                              )
                                            : TextSpan(),
                                        principleList2_note != ''
                                            ? TextSpan(
                                                text:
                                                    '、\n$principleList2_name ($principleList2_note)　',
                                              )
                                            : TextSpan(),
                                        principleList3_note != ''
                                            ? TextSpan(
                                                text:
                                                    '、\n$principleList3_name ($principleList3_note)　',
                                              )
                                            : TextSpan(),
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
                                        TextSpan(
                                          text:
                                              '$jingluoListV0_name$jingluoListV0_note、\n',
                                        ),
                                        TextSpan(
                                          text:
                                              '$jingluoListV1_name$jingluoListV1_note、\n',
                                        ),
                                        TextSpan(
                                          text:
                                              '$jingluoListV2_name$jingluoListV2_note、\n',
                                        ),
                                        TextSpan(
                                          text:
                                              '$jingluoListV3_name$jingluoListV3_note、\n',
                                        ),
                                        TextSpan(
                                          text:
                                              '$jingluoListV4_name$jingluoListV4_note\n',
                                        ),
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
