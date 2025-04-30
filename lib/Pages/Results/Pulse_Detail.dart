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
          height: MediaQuery.of(context).size.height - 170,
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

                    String cunresultPulsepospopulardesc =
                        cunResult['pulsePosPopularDesc'];
                    String cunresultPulsepos = cunResult['pulsePos'];

                    String cunresultPulsefreqpopulardesc =
                        cunResult['pulseFreqPopularDesc'];
                    String cunresultPulsefreq = cunResult['pulseFreq'];

                    String cunresultPulsepeakpopulardesc =
                        cunResult['pulsePeakPopularDesc'];
                    String cunresultPulsepeak = cunResult['pulsePeak'];

                    String cunresultFluencypopulardesc =
                        cunResult['fluencyPopularDesc'];
                    String cunresultFluency = cunResult['fluency'];

                    String cunresultTensionpopulardesc =
                        cunResult['tensionPopularDesc'];
                    String cunresultTension = cunResult['tension'];
//=========================   guanResult  ========================
                    String guanresultPulsepospopulardesc =
                        guanResult['pulsePosPopularDesc'];
                    String guanresultPulsefreqpopulardesc =
                        guanResult['pulseFreqPopularDesc'];
                    String guanresultPulsepeakpopulardesc =
                        guanResult['pulsePeakPopularDesc'];
                    String guanresultFluencypopulardesc =
                        guanResult['fluencyPopularDesc'];
                    String guanresultTensionpopulardesc =
                        guanResult['tensionPopularDesc'];
                    String guanresultPulsepos = guanResult['pulsePos'];
                    String guanresultPulsefreq = guanResult['pulseFreq'];
                    String guanresultPulsepeak = guanResult['pulsePeak'];
                    String guanresultFluency = guanResult['fluency'];
                    String guanresultTension = guanResult['tension'];
//=========================   chiResult  ========================

                    String chiresultPulsepospopulardesc =
                        chiResult['pulsePosPopularDesc'];
                    String chiresultPulsefreqpopulardesc =
                        chiResult['pulseFreqPopularDesc'];
                    String chiresultPulsepeakpopulardesc =
                        chiResult['pulsePeakPopularDesc'];
                    String chiresultFluencypopulardesc =
                        chiResult['fluencyPopularDesc'];
                    String chiresultTensionpopulardesc =
                        chiResult['tensionPopularDesc'];
                    String chiresultPulsepos = chiResult['pulsePos'];
                    String chiresultPulsefreq = chiResult['pulseFreq'];
                    String chiresultPulsepeak = chiResult['pulsePeak'];
                    String chiresultFluency = chiResult['fluency'];
                    String chiresultTension = chiResult['tension'];
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CategoryWidget(title: posType == "0" ? '左手' : '右手'),
                          Image.asset('assets/images/chi$index.png'),
                          const SizedBox(height: 15),
// ==========================================       chi result ===============================================
                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$cunresultPulsepos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunresultPulsepospopulardesc',
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
                                    text: '$cunresultFluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunresultFluencypopulardesc',
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
                                    text: '$cunresultPulsepeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunresultPulsepeakpopulardesc',
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
                                    text: '$cunresultPulsefreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunresultPulsefreqpopulardesc',
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
                                    text: '$cunresultTension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $cunresultTensionpopulardesc\n\n',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// ==========================================       cun result ===============================================

                          Image.asset('assets/images/cun$index.png'),
                          const SizedBox(height: 15),

                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$guanresultPulsepos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanresultPulsepospopulardesc',
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
                                    text: '$guanresultFluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanresultFluencypopulardesc',
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
                                    text: '$guanresultPulsepeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanresultPulsepeakpopulardesc',
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
                                    text: '$guanresultPulsefreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanresultPulsefreqpopulardesc',
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
                                    text: '$guanresultTension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $guanresultTensionpopulardesc\n\n',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),

// ==========================================       guan result ===============================================

                          Image.asset('assets/images/gun$index.png'),
                          const SizedBox(height: 15),

                          RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Textbox('脈の位置',
                                      const Color.fromARGB(255, 224, 151, 91)),
                                ),
                                TextSpan(
                                    text: '$chiresultPulsepos : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiresultPulsepospopulardesc',
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
                                    text: '$chiresultFluency : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiresultFluencypopulardesc',
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
                                    text: '$chiresultPulsepeak : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiresultPulsepeakpopulardesc',
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
                                    text: '$chiresultPulsefreq : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiresultPulsefreqpopulardesc',
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
                                    text: '$chiresultTension : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' $chiresultTensionpopulardesc',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ]),
                              softWrap: true),
                        ],
                      ),
                    );
                  }),
          SizedBox(height: 20)
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
