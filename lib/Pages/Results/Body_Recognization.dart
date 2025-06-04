import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';

class BodyRecognization extends StatefulWidget {
  const BodyRecognization(
      {super.key, required this.title, required this.visitDate});
  final String title;
  final String visitDate;
  @override
  State<BodyRecognization> createState() => _BodyRecognizationState();
}

class _BodyRecognizationState extends State<BodyRecognization> {
  List<dynamic> physiqueList = [];
  @override
  void initState() {
    getDate();
    super.initState();
  }

  getDate() async {
    final _pulseResult = await getPulseResult();
    if (mounted) {
      setState(() {});
    }
    if (_pulseResult == null) {
    } else {
      if (mounted) {
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
                    child: Column(
                      children: [
                        Image.asset('assets/images/bodychart.png'),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: physiqueList.length,
                            itemBuilder: (context, index) {
                              String name = physiqueList[index]['name'];
                              console([name]);
                              String body = physiqueList[index]['body'];
                              String mental = physiqueList[index]['mental'];
                              String jianJia = '';
                              final _jianJia = physiqueList[index]['jianJia'];
                              if (_jianJia is String) {
                                jianJia = _jianJia;
                              }
                              // console([physiqueList]);
                              String performance =
                                  physiqueList[index]['performance'];
                              List<dynamic> imageList =
                                  physiqueList[index]['images'];
                              return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, progress) {
                                                return progress == null
                                                    ? child
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator());
                                              }, errorBuilder: (context, error,
                                                      stackTrace) {
                                                return Icon(Icons.error);
                                              });
                                            }).toList(),
                                          )),
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                            text: '【$name】'),
                                      ),
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
                                            TextSpan(text: '$performance'),
                                          ],
                                        ),
                                      ),
                                      name != '平和質'
                                          ? RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: '• 兼挟み体質： ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(text: '$jianJia'),
                                                ],
                                              ),
                                            )
                                          : Text(''),
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
