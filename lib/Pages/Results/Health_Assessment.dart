import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class HealthAssessment extends StatefulWidget {
  const HealthAssessment(
      {super.key, required this.title, required this.visitDate});
  final String title;
  final String visitDate;
  @override
  State<HealthAssessment> createState() => _HealthAssessmentState();
}

class _HealthAssessmentState extends State<HealthAssessment> {
  List<dynamic> physiqueList = [];
  @override
  void initState() {
    getDate();
    super.initState();
  }

  List healthAssessments0 = [];
  List healthAssessments1 = [];
  List symptoms0 = [];
  List symptoms1 = [];
  // ignore: non_constant_identifier_names
  String healthAssessments_overview = '';
  String symptom0 = '';
  String symptom1 = '';
  String symptom2 = '';
  String symptom3 = '';
  String symptom4 = '';
  String symptom5 = '';
  List symptoms = [];

  String desc0 = '';
  String desc1 = '';
  String desc2 = '';
  String desc3 = '';
  String desc4 = '';
  String desc5 = '';
  List descs = [];

  String imageUrl = '';

  getDate() async {
    final _pulseResult = await getPulseResult(widget.visitDate);
    if (mounted) {
      setState(() {});
    }
    if (_pulseResult == null) {
    } else {
      if (mounted) {
        physiqueList = _pulseResult['physiqueList'];
        healthAssessments0 = physiqueList[0]['healthAssessments'];
        healthAssessments1 = physiqueList[1]['healthAssessments'];
        healthAssessments_overview = healthAssessments0[0]['overview'];
        imageUrl = healthAssessments0[0]['images'][0]['path'];
        symptoms0 = healthAssessments0[0]['symptoms'];
        symptoms1 = healthAssessments1[0]['symptoms'];
        console([symptoms0, symptoms1]);
        symptom0 = symptoms0[0]['symptom'];
        symptom1 = symptoms0[1]['symptom'];
        symptom2 = symptoms0[2]['symptom'];
        symptom3 = symptoms1[0]['symptom'];
        symptom4 = symptoms1[1]['symptom'];
        symptom5 = symptoms1[2]['symptom'];
        symptoms = [symptom0, symptom1, symptom2, symptom3, symptom4, symptom5];

        desc0 = symptoms0[0]['desc'];
        desc1 = symptoms0[1]['desc'];
        desc2 = symptoms0[2]['desc'];
        desc3 = symptoms1[0]['desc'];
        desc4 = symptoms1[1]['desc'];
        desc5 = symptoms1[2]['desc'];
        descs = [desc0, desc1, desc2, desc3, desc4, desc5];

        setState(() {
          physiqueList = _pulseResult['physiqueList'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          TitleWidget(title: widget.title),
          Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height - 170,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 40),
                                healthAssessmentsCard(symptom0),
                                healthAssessmentsCard(symptom1),
                                healthAssessmentsCard(symptom2),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Image.network(
                                    'http://mzy-jp.dajingtcm.com/double-ja/$imageUrl',
                                    fit: BoxFit.contain,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : Center(
                                          child: CircularProgressIndicator());
                                }, errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                })),
                            Column(
                              children: [
                                healthAssessmentsCard(symptom3),
                                healthAssessmentsCard(symptom4),
                                healthAssessmentsCard(symptom5),
                              ],
                            ),
                          ],
                        ),
                        RichText(
                            text: TextSpan(
                          text: '発生する可能性のある、または発生するリスクには次のようなものがあります：',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: symptoms.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: RichText(
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                    TextSpan(
                                        text: '• ',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 30)),
                                    WidgetSpan(
                                        child: Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Text('${symptoms[index]}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    textBaseline: TextBaseline
                                                        .alphabetic)))),
                                    TextSpan(
                                        text: '\n${descs[index]}',
                                        style: TextStyle(fontSize: 14)),
                                  ])));
                            }),
                      ],
                    ),
                  ))))
        ],
      ),
    );
  }

  Widget healthAssessmentsCard(String title) {
    return Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width * 0.2,
        height: MediaQuery.sizeOf(context).width * 0.2,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 217, 250, 234),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: const Color.fromARGB(255, 113, 212, 158))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
