import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key, required this.title});
  final String title;
  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
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
          SizedBox(
              height: MediaQuery.of(context).size.height - 170,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: physiquePlanList.length,
                        itemBuilder: (context, index) {
                          String overview = physiquePlanList[index]['overview'];
                          String suggestion =
                              physiquePlanList[index]['suggestion'];
                          String recommend =
                              physiquePlanList[index]['recommend'];
                          List<dynamic> imageList =
                              physiquePlanList[index]['images'];
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
                                              fit: BoxFit.cover, loadingBuilder:
                                                  (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          }, errorBuilder:
                                                  (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          });
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
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\n${suggestion.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
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
                                              '\n${recommend.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
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
