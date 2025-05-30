import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/globaldata.dart';

/// Flutter code sample for [Table].

void main() => runApp(const TableExampleApp());

class TableExampleApp extends StatelessWidget {
  const TableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Table Sample')),
          body: const TableExample()),
    );
  }
}

class TableExample extends StatelessWidget {
  const TableExample({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Table(
      border: TableBorder.all(),
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(size.width * 0.2 - 1),
        1: FixedColumnWidth(size.width * 0.8 - 1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 221, 152, 49)),
          children: <Widget>[
            Container(
              child: Text(
                '体質種類',
                style: TextStyle(
                    fontSize: 16,
                    backgroundColor: const Color.fromARGB(255, 221, 152, 49)),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Text(
                '体質スコアの詳細',
                style: TextStyle(
                    fontSize: 18,
                    backgroundColor: const Color.fromARGB(255, 221, 152, 49)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '気虚質\n(ききょしつ)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text:
                          '「気」（生命エネルギー）が不足しがちな体質です。\n気虚質のスコアが高いと風邪をひきやすく常に疲労を感じるなど、エネルギー切れの症状が出やすいことを意味します。具体的には体力がなく免疫力も低めで、肌は乾燥しやすく、性格的には内向的で気力に欠ける傾向があります。',
                    ),
                    TextSpan(
                        text: '対策として、冷たい物や生ものを避けて胃腸に優しい温かい食事を心がけましょう。',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          '気虚質のスコアが低ければ、気（エネルギー）が充実していて疲れにくく、体力や免疫もしっかりしていると考えられます。',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '陽虚質\nようきょしつ)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '体を温める「陽気」が不足している体質です。\n陽虚質が高スコアの場合、いつも手足が冷えて寒がりであるなど、慢性的な冷え性体質を示します​。服を人より多く着込まないと寒さに耐えられなかったり、むくみやすい、水分代謝が悪いなどの傾向もあります。これは体内の機能低下にもつながりがちです。',
                  ),
                  TextSpan(
                      text: '対策として、常に体を温めるものを摂るようにしましょう。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '陽虚のスコアが低ければ、身体を温める力が十分にあり、冷えに悩まされにくい状態といえます。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '陰虚質\nいんきょしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '体の潤い（陰液）が不足しがちな体質です。\n陰虚のスコアが高いと全身の潤い不足によって体がほてりやすく、皮膚や粘膜が乾燥しやすい状態を示します。例えば手のひらや足裏が熱くなりがちで寝汗をかく、喉の渇きや空咳が出るなど陰虚の典型症状が出やすくなります​。活発で外向的だがエネルギー消耗が激しいタイプとも言われます。',
                  ),
                  TextSpan(
                      text: '水分補給が大事です。睡眠や休息をしっかりとり、オーバーワークで体を熱化させないようにしましょう。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '陰虚のスコアが低い場合、体内の潤いバランスは良好で、乾燥やのぼせといった症状が出にくい状態です。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '瘀血質\nおけつしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '血の巡りが悪く滞りがちな体質です。\n瘀血質が高スコアの場合、皮膚の色がくすんで暗めで顔にシミやソバカス、目の下のクマが出やすいなど、血行不良のサインが強く出ていることを意味します​。肩こりや頭痛、手足の冷え、生理不順なども現れやすい傾向があります。精神的にもイライラしやすく焦りがちな傾向があります。',
                  ),
                  TextSpan(
                      text: 'ストレッチやウォーキングのような適度な運動は瘀血解消の最も効果的な方法の一つです。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '瘀血のスコアが低ければ、血流は比較的スムーズで、血行不良による不調リスクは小さいでしょう。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '痰湿質\nたんしつしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '余分な水分や脂肪が体に滞りやすい体質です。\n痰湿質が高スコアの場合、ぽっちゃりとした体形で汗や皮脂がベタつきやすく、身体が常に重だるいといった特徴が強くなります​。',
                  ),
                  TextSpan(
                      text:
                          ' 余分な水分や脂肪をためないように食習慣の見直しが必須です。お酒を控え、食べ過ぎない（腹八分目）習慣をつけましょう。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '痰湿のスコアが低ければ、水分・脂肪代謝は良好で、余分な水分や老廃物が溜まりにくい体質と言えます。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '気鬱質\nきうつしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        'ストレスにより「気」が滞りやすい体質（気滞とも言います）です。\n気鬱質が高スコアの場合、精神的に落ち込みやすく不安感が強い傾向を示し、不眠症やうつ状態になりやすいタイプであることを意味します​。情緒が不安定で、胸や喉に詰まりを感じたりため息が多くなるといった症状も出やすいです。',
                  ),
                  TextSpan(
                      text:
                          '最大のポイントはストレス解消とリラックスです。好きな音楽を聴いたり入浴でリフレッシュする時間を作り、ヨガや散歩など適度な運動で気分転換するのも有効です。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        '気鬱のスコアが低ければ、気の巡りが良くメンタル面は安定しており、ストレスによる不調は起こりにくいでしょう。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '湿熱質\nしつねつしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '体内に余分な「湿」（水分）と「熱」がこもりやすい体質です。\n湿熱質のスコアが高いと、皮膚が脂っぽくテカリ気味でニキビや吹き出物ができやすいことを示します。また口の中が苦く感じたり、口臭が出たり、便がねばついてすっきり出ない・尿が熱っぽいなどの傾向も強まります​。これは体内に炎症や過剰な熱があるサインです。',
                  ),
                  TextSpan(
                      text: '辛辣な刺激物や油っこい物は体に熱と湿気を溜め込むので控えましょう。',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '湿熱のスコアが低ければ、そうした湿熱症状は出にくく、体内の水分と熱のバランスは比較的正常です。',
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: <Widget>[
            Text(
              '平和質\nへいわしつ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        'いわゆる「バランスの取れた」体質です。\n疲れにくく精力旺盛で、暑さ寒さに強く、睡眠や食欲も良好な健康優良タイプで、病気にかかりにくいのが特徴です​。',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
