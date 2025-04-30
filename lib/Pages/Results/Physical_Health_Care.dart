import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';

import 'package:pulse_diagnosis/globaldata.dart';

class Physical_Health_Care extends StatefulWidget {
  final String title;
  const Physical_Health_Care({super.key, required this.title});

  @override
  State<Physical_Health_Care> createState() => _Physical_Health_CareState();
}

class _Physical_Health_CareState extends State<Physical_Health_Care> {
  List<dynamic> healthPlanResult = [];
  List<dynamic> physiotherapyCareList = [];
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
          healthPlanResult =
              globalData.pulseResult['healthPlan']['acupointList'];
          physiotherapyCareList =
              globalData.pulseResult['physiotherapyCareListV2'];
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
                child: Column(children: [
              CategoryWidget(title: 'マッサージ'),
              ListView.builder(
                // physics: AlwaysScrollableScrollPhysics(),
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                itemCount: healthPlanResult.length,
                itemBuilder: (context, index) {
                  final result = healthPlanResult[index];
                  List<dynamic> imageList = result['images'];
                  String operation = result['operation'];
                  String position = result['position'];
                  String effect = result['effect'];
                  String belong = result['belong'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    // child: Padding(
                    // padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imageList.map((image) {
                                final url =
                                    "http://mzy-jp.dajingtcm.com/double-ja/${image['path']}";
                                String name = image['name'];
                                return Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      foregroundDecoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: MediaQuery.of(context).size.width *
                                          0.5 /
                                          imageList.length,
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: Image(
                                          image: NetworkImage(url),
                                          fit: BoxFit.fitWidth,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          }),
                                    ),
                                    Positioned(
                                        bottom: -8,
                                        width: 90,
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            padding: EdgeInsets.all(6),
                                            child: Text(name,
                                                style: TextStyle(
                                                    color: Colors.white))))
                                  ],
                                );
                              }).toList(),
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(operation,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text('• 位置: $position'),
                              Text('• 効果: $effect'),
                              Text('• 経属: $belong', textAlign: TextAlign.start),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              // ),
              // Expanded(
              //   child:

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: physiotherapyCareList.length,
                itemBuilder: (context, index) {
                  var careItem = physiotherapyCareList[index];

                  if (careItem.containsKey('list')) {
                    final listItems = careItem['list'] as List;
                    final listItems1 = careItem['list'][0];
                    String type = careItem['type'];
                    if (type == '刮痧') {
                      var images = listItems1['images'] as List;
                      String acupoint = listItems1['acupoint'];
                      String principle = listItems1['principle'];
                      String operation = listItems1['operation'];
                      String efficacy = listItems1['efficacy'];
                      String precaution = listItems1['precaution'];
                      String contraindication = listItems1['contraindication'];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CategoryWidget(title: type),
                            // ...listItems.map((listItem) {
                              // var images = listItem['images'] as List;
                              // String acupoint = listItem['acupoint'];
                              // String principle = listItem['principle'];
                              // String operation = listItem['operation'];
                              // String efficacy = listItem['efficacy'];
                              // String precaution = listItem['precaution'];
                              // String contraindication =
                              //     listItem['contraindication'];
                              // return
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            NeverScrollableScrollPhysics(), // Prevents nested scrolling
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, // Two columns
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio:
                                              1, // Adjust as needed
                                        ),
                                        itemCount: images.length,
                                        itemBuilder: (context, imgIndex) {
                                          String name =
                                              images[imgIndex]['name'];
                                          String imagePath =
                                              "http://mzy-jp.dajingtcm.com/double-ja/${images[imgIndex]['path']}";
                                          // "http://mzy-jp.dajingtcm.com/double-ja/material/2024/11/21/8ba1f08b1acd0320f556c49087fccd14.png";
                                          return Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                foregroundDecoration:
                                                    BoxDecoration(
                                                        border:
                                                            Border.all(
                                                                color:
                                                                    Colors
                                                                        .blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                child: Image(
                                                    image:
                                                        NetworkImage(imagePath),
                                                    fit: BoxFit.fitWidth,
                                                    loadingBuilder: (context,
                                                        child, progress) {
                                                      return progress == null
                                                          ? child
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(Icons.error);
                                                    }),
                                              ),
                                              Positioned(
                                                  bottom: -8,
                                                  width: 100,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        name,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )))
                                            ],
                                          );
                                        },
                                      ),
                                      Text(
                                          '\n ${operation.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      // Text(
                                      //     '• 操作方法： \n ${principle.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}'),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors
                                                  .black), // Default text style
                                          children: [
                                            TextSpan(
                                              text: '• 操作方法： ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Bold "効果"
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${principle.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal), // Normal style for the rest of the text
                                            ),
                                          ],
                                        ),
                                      ),

                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors
                                                  .black), // Default text style
                                          children: [
                                            TextSpan(
                                              text: '• 効果： ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Bold "効果"
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${efficacy.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal), // Normal style for the rest of the text
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors
                                                  .black), // Default text style
                                          children: [
                                            TextSpan(
                                              text: '• 注意事項： ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Bold "効果"
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${precaution.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal), // Normal style for the rest of the text
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors
                                                  .black), // Default text style
                                          children: [
                                            TextSpan(
                                              text: '• 禁忌症： ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Bold "効果"
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${contraindication.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal), // Normal style for the rest of the text
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            // }).toList(),
                          ]);
                    }
                  }
                  return SizedBox.shrink(); // Empty placeholder if no list
                },
              ),
            ])))
      ],
    ));
  }
}
