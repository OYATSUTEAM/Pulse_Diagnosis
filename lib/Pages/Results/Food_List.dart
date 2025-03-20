import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class FoodList extends StatefulWidget {
  const FoodList({super.key, required this.title});
  final String title;
  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  List<dynamic> physiquePlanList = [];
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
              height: MediaQuery.of(context).size.height - 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: physiquePlanList.length,
                        itemBuilder: (context, index) {
                          String should = physiquePlanList[index]['should'];
                          String avoid = physiquePlanList[index]['avoid'];
                          return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(10),
                              child: Column(children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: 'よろしい ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 20),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n${should.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .normal), // Normal style for the rest of the text
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: 'いや ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 20),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n${avoid.replaceAll('&nbsp', ' ').replaceAll('<br/>\n', '\n')}\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .normal), // Normal style for the rest of the text
                                      ),
                                    ],
                                  ),
                                ),
                              ]));
                        })
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
