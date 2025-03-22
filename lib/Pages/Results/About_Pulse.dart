import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:pulse_diagnosis/Widgets/Table.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class AboutPulse extends StatefulWidget {
  const AboutPulse({super.key});

  @override
  State<AboutPulse> createState() => _AboutPulseState();
}

class _AboutPulseState extends State<AboutPulse> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Icon(Icons.arrow_forward_ios),
            ),
            body: Padding(
              padding: EdgeInsets.all(0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/about_background.png',
                            width: globalData.s_width,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: '　体質',
                                      style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    text:
                                        'とは、生まれつきの遺伝要因だけでなく、生活習慣や環境、食事や運動、さらには精神状態などが複雑に関わり合って形成される、身体と精神両面の総合的な特徴を指します。\n\n',
                                  ),
                                 TextSpan(
                                      text: '　体質スコア',
                                      style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                    TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    text:
                                        'は、各体質の傾向を数値化したものです。スコアが高い体質ほどその影響が強く現れ、逆にスコアが低い体質は影響が小さいと考えられます。\n\n',
                                  ),
                                  TextSpan(
                                      text: '　以下',
                                      style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                    TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    text:
                                        'では、各体質の特徴とスコアの関係性、全体のバランス、スコアが高い体質の健康への影響、スコアが低い体質の意味を説明いたします。生活習慣を整えることで、体質スコアは改善されます。',
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(10), child: TableExample())
                    ],
                  ),
                ),
              ),
            )));
  }
}
