import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';

class EightPrinciple extends StatefulWidget {
  const EightPrinciple(
      {super.key, required this.title, required this.visitDate});
  final String title;
  final String visitDate;
  @override
  State<EightPrinciple> createState() => _EightPrincipleState();
}

class _EightPrincipleState extends State<EightPrinciple> {
  List<dynamic> principleList = [];
  @override
  void initState() {
    getDate();
    super.initState();
  }

  List principleListImages = [];
  getDate() async {
    final _pulseResult = await getPulseResult();
    if (mounted) {
      setState(() {});
    }
    if (_pulseResult == null) {
      console(['']);
    } else {
      if (mounted) {
        setState(() {
          principleList = _pulseResult['principleList'];
          principleListImages = ['ri.png', 'ji.png', 'yon.png', 'jang.png'];
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
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
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
                                Image.asset(
                                    'assets/images/${principleListImages[index]}'),
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
                  //   ],
                  // ),
                  ))
        ],
      ),
    );
  }
}
