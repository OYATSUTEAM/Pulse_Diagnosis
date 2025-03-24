import 'package:flutter/material.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  State<AboutBody> createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 68, 171, 255),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
            child: Text('体質種類と体質スコアの詳細',
                style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),),
          ),
         SizedBox(height: 20,),
          Text('気虚質(ききょしつ)', style: TextStyle(fontSize: 17),),
          RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text:
                          '\n「気」（生命エネルギー）が不足しがちな体質です。\n気虚質のスコアが高いと風邪をひきやすく常に疲労を感じるなど、エネルギー切れの症状が出やすいことを意味します。具体的には体力がなく免疫力も低めで、肌は乾燥しやすく、性格的には内向的で気力に欠ける傾向があります。\n',
                    ),
                    TextSpan(
                        text: '対策として、冷たい物や生ものを避けて胃腸に優しい温かい食事を心がけましょう。\n',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          '気虚質のスコアが低ければ、気（エネルギー）が充実していて疲れにくく、体力や免疫もしっかりしていると考えられます。',
                    ),
                  ],
          )),
       
       
       
       
       
        ],
      ),
    );
  }
}
