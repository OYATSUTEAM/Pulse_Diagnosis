import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class FoodList extends StatefulWidget {
  const FoodList({super.key, required this.title, required this.visitDate});
  final String title;
  final String visitDate;
  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  List<dynamic> physiquePlanList = [];
  @override
  void initState() {
    getDate();
    super.initState();
  }

  getDate() async {
    final _pulseResult = await getPulseResult(widget.visitDate);
    if (mounted) {
      setState(() {});
    }
    if (_pulseResult == null) {
    } else {
      if (mounted) {
        setState(() {
          physiquePlanList = _pulseResult['physiquePlanList'];
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
                        Image.asset('assets/images/food.png'),
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
                  )))
        ],
      ),
    );
  }
}
