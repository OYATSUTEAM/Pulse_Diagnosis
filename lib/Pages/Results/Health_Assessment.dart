import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class HealthAssessment extends StatefulWidget {
  const HealthAssessment({super.key, required this.title});
  final String title;
  @override
  State<HealthAssessment> createState() => _HealthAssessmentState();
}

class _HealthAssessmentState extends State<HealthAssessment> {
  List<dynamic> physiqueList = [];
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
          physiqueList = globalData.pulseResult['physiqueList'];
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
                        itemCount: physiqueList.length,
                        itemBuilder: (context, index) {
                          final healthAssessments =
                              physiqueList[index]['healthAssessments'];
                          String overview = healthAssessments[0]['overview'];
                          List<dynamic> imageList =
                              healthAssessments[0]['images'];
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
                                          return Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          );
                                        }).toList(),
                                      )),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\n${overview.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
