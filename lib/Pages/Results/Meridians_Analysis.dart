import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class MeridiansAnalysis extends StatefulWidget {
  const MeridiansAnalysis({super.key, required this.title});
  final String title;
  @override
  State<MeridiansAnalysis> createState() => _MeridiansAnalysisState();
}

class _MeridiansAnalysisState extends State<MeridiansAnalysis> {
  List<dynamic> jingluoListV2 = [];
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
          jingluoListV2 = globalData.pulseResult['jingluoListV2'];
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
          SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: jingluoListV2.length,
                        itemBuilder: (context, index) {
                          String main = jingluoListV2[index]['main'];
                          String mainSymptom =
                              jingluoListV2[index]['mainSymptom'];
                          String minor = jingluoListV2[index]['minor'];
                          String minorSymptom =
                              jingluoListV2[index]['minorSymptom'];
                          List<dynamic> imageList =
                              jingluoListV2[index]['images'];
                          return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: imageList.map((image) {
                                          final imageUrl =
                                              "http://mzy-jp.dajingtcm.com/double-ja/${image['path']}";
                                          return Image.network(imageUrl,
                                              fit: BoxFit.cover);
                                        }).toList(),
                                      )),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${main.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        TextSpan(
                                          text:
                                              '    ${jingluoListV2[index]['mainGrade']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${mainSymptom.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${minor.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        TextSpan(
                                          text:
                                              '    ${jingluoListV2[index]['minorGrade']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\n${minorSymptom.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ));
                        })
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
