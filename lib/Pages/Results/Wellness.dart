import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';
import 'package:pulse_diagnosis/Widgets/title.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class Wellness extends StatefulWidget {
  const Wellness({super.key, required this.title});
  final String title;

  @override
  State<Wellness> createState() => _WellnessState();
}

class _WellnessState extends State<Wellness> {
  List<dynamic> wellnessList = [];

  @override
  void initState() {
    getDate();
  }

  getDate() async {
    while (globalData.pulseResult.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (mounted) {
      if (globalData.pulseResult.isNotEmpty) {
        setState(() {
          wellnessList = globalData.pulseResult['wellnessListV2'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    console([wellnessList.length]);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TitleWidget(title: widget.title),
          Expanded(
              child: ListView.builder(
            itemCount: wellnessList.length,
            itemBuilder: (context, index) {
              var item = wellnessList[index];
              var imageUrl = item["images"][0]["path"];
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null)
                        Image.network(
                            'http://mzy-jp.dajingtcm.com/double-ja/$imageUrl',
                            fit: BoxFit.cover),
                      Text(item["type"],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("${item["bodyPart"]}",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 5),
                      Text(item["content"], style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                    ],
                  ),
                
              );
            },
          )),
        ],
      ),
    ));
  }
}
