import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class EightPrinciple extends StatefulWidget {
  const EightPrinciple({super.key, required this.title});
  final String title;
  @override
  State<EightPrinciple> createState() => _EightPrincipleState();
}

class _EightPrincipleState extends State<EightPrinciple> {
  List<dynamic> principleList = [];
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
          principleList = globalData.pulseResult['principleList'];
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
                        itemCount: principleList.length,
                        itemBuilder: (context, index) {
                          String name = principleList[index]['name'];
                          String desc = principleList[index]['desc'];
                          // List<dynamic> imageList =
                          //     principleList[index]['images'];
                          return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Padding(
                                  //     padding:
                                  //         EdgeInsets.symmetric(vertical: 10),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: imageList.map((image) {
                                  //         final imageUrl =
                                  //             "http://mzy-jp.dajingtcm.com/double-ja/${image['path']}";
                                  //         return Image.network(
                                  //             imageUrl,
                                  //             fit: BoxFit.cover);
                                  //       }).toList(),
                                  //     )),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: name,
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
                                          text: desc,
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
