import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class BodyRecognization extends StatefulWidget {
  const BodyRecognization({super.key, required this.title});
  final String title;
  @override
  State<BodyRecognization> createState() => _BodyRecognizationState();
}

class _BodyRecognizationState extends State<BodyRecognization> {
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
                          String body = physiqueList[index]['body'];
                          String mental = physiqueList[index]['mental'];
                          String performance =
                              physiqueList[index]['performance'];
                          List<dynamic> imageList =
                              physiqueList[index]['images'];
                          return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          text: '• 全体的特徴： ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: '$body'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: '• 常見の症候： ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: '$mental'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: '• 兼挟み体質： ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: '$performance'),
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
