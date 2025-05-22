import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class PlanYourHealth extends StatefulWidget {
  const PlanYourHealth({super.key, required this.title});
  final String title;
  @override
  State<PlanYourHealth> createState() => _PlanYourHealthState();
}

class _PlanYourHealthState extends State<PlanYourHealth> {
  List<dynamic> physiquePlanList = [];
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
      console(['']);
    } else {
      if (mounted) {
        setState(() {
          physiquePlanList = globalData.pulseResult['physiquePlanList'];
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
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: physiquePlanList.length,
                            itemBuilder: (context, index) {
                              final physique_index = physiquePlanList[index];
                              String name = physique_index['name'];
                              String should = physique_index['should'];
                              String avoid = physique_index['avoid'];
                              String dietSummary =
                                  physique_index['dietSummary'];
                              String overview = physique_index['overview'];
                              String exerciseSummary =
                                  physique_index['exerciseSummary'];
                              String suggestion = physique_index['suggestion'];
                              String recommend = physique_index['recommend'];
                              List<dynamic> imageList =
                                  physique_index['images'];
                              return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
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
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${name.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${should.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${avoid.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${dietSummary.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${overview.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${exerciseSummary.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${suggestion.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                              text:
                                                  '\n${recommend.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ])),
                                    ],
                                  ));
                            })
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
