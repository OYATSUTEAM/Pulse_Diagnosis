import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:pulse_diagnosis/Widgets/About_Body.dart';
import 'package:pulse_diagnosis/Widgets/Table.dart';
import 'package:pulse_diagnosis/Widgets/category.dart';

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
                        child: Column(children: [
                  Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/images/about_background.jpg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 40),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                                // offset: Offset(0, -30),
                                child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 68, 171, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                  child: Text('体質種類と体質スコアの詳細',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white))),
                            )),
                            TextSpan(
                                text: '\n\n　体質',
                                style: TextStyle(fontSize: 20)),
                            TextSpan(
                              text:
                                  'とは、生まれつきの遺伝要因だけでなく、生活習慣や環境、食事や運動、さらには精神状態などが複雑に関わり合って形成される、身体と精神両面の総合的な特徴を指します。\n\n',
                            ),
                            TextSpan(
                                text: '　体質スコア', style: TextStyle(fontSize: 20)),
                            TextSpan(
                              text:
                                  'は、各体質の傾向を数値化したものです。スコアが高い体質ほどその影響が強く現れ、逆にスコアが低い体質は影響が小さいと考えられます。\n\n',
                            ),
                            TextSpan(
                                text: '　以下', style: TextStyle(fontSize: 20)),
                            TextSpan(
                              text:
                                  'では、各体質の特徴とスコアの関係性、全体のバランス、スコアが高い体質の健康への影響、スコアが低い体質の意味を説明いたします。生活習慣を整えることで、体質スコアは改善されます。',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n気虚質(ききょしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n「気」（生命エネルギー）が不足しがちな体質です。\n気虚質のスコアが高いと風邪をひきやすく常に疲労を感じるなど、エネルギー切れの症状が出やすいことを意味します。具体的には体力がなく免疫力も低めで、肌は乾燥しやすく、性格的には内向的で気力に欠ける傾向があります。\n',
                            ),
                            TextSpan(
                                text:
                                    '\n対策として、冷たい物や生ものを避けて胃腸に優しい温かい食事を心がけましょう。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n気虚質のスコアが低ければ、気（エネルギー）が充実していて疲れにくく、体力や免疫もしっかりしていると考えられます。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                  Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n陽虚質(ようきょしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n体を温める「陽気」が不足している体質です。\n陽虚質が高スコアの場合、いつも手足が冷えて寒がりであるなど、慢性的な冷え性体質を示します​。服を人より多く着込まないと寒さに耐えられなかったり、むくみやすい、水分代謝が悪いなどの傾向もあります。これは体内の機能低下にもつながりがちです。\n',
                            ),
                            TextSpan(
                                text: '\n対策として、常に体を温めるものを摂るようにしましょう。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n陽虚のスコアが低ければ、身体を温める力が十分にあり、冷えに悩まされにくい状態といえます。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                  Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n陰虚質(いんきょしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n体の潤い（陰液）が不足しがちな体質です。\n陰虚のスコアが高いと全身の潤い不足によって体がほてりやすく、皮膚や粘膜が乾燥しやすい状態を示します。例えば手のひらや足裏が熱くなりがちで寝汗をかく、喉の渇きや空咳が出るなど陰虚の典型症状が出やすくなります​。活発で外向的だがエネルギー消耗が激しいタイプとも言われます。\n',
                            ),
                            TextSpan(
                                text:
                                    '\n水分補給が大事です。睡眠や休息をしっかりとり、オーバーワークで体を熱化させないようにしましょう。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n陰虚のスコアが低い場合、体内の潤いバランスは良好で、乾燥やのぼせといった症状が出にくい状態です。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                  Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n瘀血質(おけつしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n血の巡りが悪く滞りがちな体質です。\n瘀血質が高スコアの場合、皮膚の色がくすんで暗めで顔にシミやソバカス、目の下のクマが出やすいなど、血行不良のサインが強く出ていることを意味します​。肩こりや頭痛、手足の冷え、生理不順なども現れやすい傾向があります。精神的にもイライラしやすく焦りがちな傾向があります。\n',
                            ),
                            TextSpan(
                                text:
                                    '\nストレッチやウォーキングのような適度な運動は瘀血解消の最も効果的な方法の一つです。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n瘀血のスコアが低ければ、血流は比較的スムーズで、血行不良による不調リスクは小さいでしょう。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ])
                 ,   Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n痰湿質(たんしつしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n余分な水分や脂肪が体に滞りやすい体質です。\n痰湿質が高スコアの場合、ぽっちゃりとした体形で汗や皮脂がベタつきやすく、身体が常に重だるいといった特徴が強くなります​。\n',
                            ),
                            TextSpan(
                                text:
                                    '\n 余分な水分や脂肪をためないように食習慣の見直しが必須です。お酒を控え、食べ過ぎない（腹八分目）習慣をつけましょう。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n痰湿のスコアが低ければ、水分・脂肪代謝は良好で、余分な水分や老廃物が溜まりにくい体質と言えます。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ])
               
                 ,   Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n気鬱質(きうつしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\nストレスにより「気」が滞りやすい体質（気滞とも言います）です。\n気鬱質が高スコアの場合、精神的に落ち込みやすく不安感が強い傾向を示し、不眠症やうつ状態になりやすいタイプであることを意味します​。情緒が不安定で、胸や喉に詰まりを感じたりため息が多くなるといった症状も出やすいです。\n',
                            ),
                            TextSpan(
                                text:
                                    '\n 最大のポイントはストレス解消とリラックスです。好きな音楽を聴いたり入浴でリフレッシュする時間を作り、ヨガや散歩など適度な運動で気分転換するのも有効です。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n気鬱のスコアが低ければ、気の巡りが良くメンタル面は安定しており、ストレスによる不調は起こりにくいでしょう。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ])
               
               
                  ,   Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n湿熱質(しつねつしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n体内に余分な「湿」（水分）と「熱」がこもりやすい体質です。\n湿熱質のスコアが高いと、皮膚が脂っぽくテカリ気味でニキビや吹き出物ができやすいことを示します。また口の中が苦く感じたり、口臭が出たり、便がねばついてすっきり出ない・尿が熱っぽいなどの傾向も強まります​。これは体内に炎症や過剰な熱があるサインです。\n',
                            ),
                            TextSpan(
                                text:
                                    '\n 辛辣な刺激物や油っこい物は体に熱と湿気を溜め込むので控えましょう。\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\n湿熱のスコアが低ければ、そうした湿熱症状は出にくく、体内の水分と熱のバランスは比較的正常です。',
                            ),
                          ],
                        ),
                      ),
                    )
                  ])
               
                 ,   Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/about_background.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Center(
                                  child: Text('\n平和質(へいわしつ)\n',
                                      style: TextStyle(fontSize: 20))),
                            ),
                            TextSpan(
                              style: TextStyle(fontSize: 15),
                              text:
                                  '\nいわゆる「バランスの取れた」体質です。\n疲れにくく精力旺盛で、暑さ寒さに強く、睡眠や食欲も良好な健康優良タイプで、病気にかかりにくいのが特徴です​。\n',
                            ),
           
                          ],
                        ),
                      ),
                    )
                  ])
               
               
               
               
               
               
               
               
               
               
               
               
               
                ]))))));
  }
}
