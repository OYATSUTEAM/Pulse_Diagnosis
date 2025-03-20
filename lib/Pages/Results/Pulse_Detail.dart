import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class PulseDetail extends StatefulWidget {
  const PulseDetail({super.key, required this.title});
  final String title;
  @override
  State<PulseDetail> createState() => _PulseDetailState();
}

class _PulseDetailState extends State<PulseDetail> {
  List<dynamic> pulseResult = [];
  @override
  void initState() {
    getDate();
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
          pulseResult = globalData.pulseResult['visitInfo']['parts'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      TitleWidget(title: widget.title),
      SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: SingleChildScrollView(
            child: Column(children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pulseResult.length,
                  itemBuilder: (context, index) {
                    final cunResult = pulseResult[index]['cunResult'];
                    final guanResult = pulseResult[index]['guanResult'];
                    final chiResult = pulseResult[index]['chiResult'];
//=========================   cunResult  ========================
                    String posType = cunResult['posType'];

                    String cunResult_pulsePosPopularDesc =
                        cunResult['pulsePosPopularDesc'];
                    String cunResult_pulsePos = cunResult['pulsePos'];

                    String cunResult_pulseFreqPopularDesc =
                        cunResult['pulseFreqPopularDesc'];
                    String cunResult_pulseFreq = cunResult['pulseFreq'];

                    String cunResult_pulsePeakPopularDesc =
                        cunResult['pulsePeakPopularDesc'];
                    String cunResult_pulsePeak = cunResult['pulsePeak'];

                    String cunResult_fluencyPopularDesc =
                        cunResult['fluencyPopularDesc'];
                    String cunResult_fluency = cunResult['fluency'];

                    String cunResult_tensionPopularDesc =
                        cunResult['tensionPopularDesc'];
                    String cunResult_tension = cunResult['tension'];
//=========================   guanResult  ========================
                    String guanResult_pulsePosPopularDesc =
                        guanResult['pulsePosPopularDesc'];
                    String guanResult_pulseFreqPopularDesc =
                        guanResult['pulseFreqPopularDesc'];
                    String guanResult_pulsePeakPopularDesc =
                        guanResult['pulsePeakPopularDesc'];
                    String guanResult_fluencyPopularDesc =
                        guanResult['fluencyPopularDesc'];
                    String guanResult_tensionPopularDesc =
                        guanResult['tensionPopularDesc'];
                    String guanResult_pulsePos = guanResult['pulsePos'];
                    String guanResult_pulseFreq = guanResult['pulseFreq'];
                    String guanResult_pulsePeak = guanResult['pulsePeak'];
                    String guanResult_fluency = guanResult['fluency'];
                    String guanResult_tension = guanResult['tension'];
//=========================   chiResult  ========================

                    String chiResult_pulsePosPopularDesc =
                        chiResult['pulsePosPopularDesc'];
                    String chiResult_pulseFreqPopularDesc =
                        chiResult['pulseFreqPopularDesc'];
                    String chiResult_pulsePeakPopularDesc =
                        chiResult['pulsePeakPopularDesc'];
                    String chiResult_fluencyPopularDesc =
                        chiResult['fluencyPopularDesc'];
                    String chiResult_tensionPopularDesc =
                        chiResult['tensionPopularDesc'];
                    String chiResult_pulsePos = chiResult['pulsePos'];
                    String chiResult_pulseFreq = chiResult['pulseFreq'];
                    String chiResult_pulsePeak = chiResult['pulsePeak'];
                    String chiResult_fluency = chiResult['fluency'];
                    String chiResult_tension = chiResult['tension'];
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryWidget(title: posType == 0 ? '左手' : '右手'),
                      
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$cunResult_pulsePos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunResult_pulsePosPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の流れ',
                                      const Color.fromARGB(255, 121, 231, 171)),
                                ),
                                TextSpan(
                                    text: '$cunResult_pulseFreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunResult_pulseFreqPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の強さ',
                                      const Color.fromARGB(255, 50, 133, 228)),
                                ),
                                TextSpan(
                                    text: '$cunResult_pulsePeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunResult_pulsePeakPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈拍数',
                                      const Color.fromARGB(255, 202, 139, 87)),
                                ),
                                TextSpan(
                                    text: '$cunResult_fluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunResult_fluencyPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('緊張度',
                                      const Color.fromARGB(255, 133, 95, 64)),
                                ),
                                TextSpan(
                                    text: '$cunResult_tension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunResult_tensionPopularDesc\n\n',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),
                       
// ==========================================       cun result ===============================================
                       
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$guanResult_pulsePos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanResult_pulsePosPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の流れ',
                                      const Color.fromARGB(255, 121, 231, 171)),
                                ),
                                TextSpan(
                                    text: '$guanResult_pulseFreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanResult_pulseFreqPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の強さ',
                                      const Color.fromARGB(255, 50, 133, 228)),
                                ),
                                TextSpan(
                                    text: '$guanResult_pulsePeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanResult_pulsePeakPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈拍数',
                                      const Color.fromARGB(255, 202, 139, 87)),
                                ),
                                TextSpan(
                                    text: '$guanResult_fluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanResult_fluencyPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('緊張度',
                                      const Color.fromARGB(255, 133, 95, 64)),
                                ),
                                TextSpan(
                                    text: '$guanResult_tension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanResult_tensionPopularDesc\n\n',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),
                       
// ==========================================       guan result ===============================================
                       
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$chiResult_pulsePos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiResult_pulsePosPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の流れ',
                                      const Color.fromARGB(255, 121, 231, 171)),
                                ),
                                TextSpan(
                                    text: '$chiResult_pulseFreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiResult_pulseFreqPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の強さ',
                                      const Color.fromARGB(255, 50, 133, 228)),
                                ),
                                TextSpan(
                                    text: '$chiResult_pulsePeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiResult_pulsePeakPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈拍数',
                                      const Color.fromARGB(255, 202, 139, 87)),
                                ),
                                TextSpan(
                                    text: '$chiResult_fluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiResult_fluencyPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// =======================

                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('緊張度',
                                      const Color.fromARGB(255, 133, 95, 64)),
                                ),
                                TextSpan(
                                    text: '$chiResult_tension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiResult_tensionPopularDesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),
                       
                       
                       
                       
                       
                       
                        ],
                      ),
                    );
                  })
            ]),
          ))
    ]));
  }
}

Widget Textbox(String type, Color color) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 2.0),
      borderRadius: BorderRadius.circular(10.0), // Optional: rounded corners
    ),
    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
    padding: EdgeInsets.all(1.0), // Padding inside the border
    child: Text(type, style: TextStyle(fontSize: 14, color: color)),
  );
}
