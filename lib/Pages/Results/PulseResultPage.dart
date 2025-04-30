import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/NavigationPage.dart';
import 'package:pulse_diagnosis/Pages/Results/Body_Recognization.dart';
import 'package:pulse_diagnosis/Pages/Results/Eight_Principle.dart';
import 'package:pulse_diagnosis/Pages/Results/Exercise_List.dart';
import 'package:pulse_diagnosis/Pages/Results/Food_List.dart';
import 'package:pulse_diagnosis/Pages/Results/Health_Assessment.dart';
import 'package:pulse_diagnosis/Pages/Results/Meridians_Analysis.dart';
import 'package:pulse_diagnosis/Pages/Results/Physical_Health_Care.dart';
import 'package:pulse_diagnosis/Pages/Results/Pulse_Detail.dart';
import 'package:pulse_diagnosis/Pages/Results/User_Page.dart';
import 'package:pulse_diagnosis/Pages/Results/Wellness.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class Pulseresultpage extends StatefulWidget {
  const Pulseresultpage({super.key});

  @override
  State<Pulseresultpage> createState() => _PulseresultpageState();
}

class _PulseresultpageState extends State<Pulseresultpage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  String title = '';
  @override
  void initState() {
    setResultData();
    super.initState();
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: 10, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
        setState(() {}); // Force rebuild
      }
    });
  }

  Future<void> setResultData() async {
    while (globalData.patientResult.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Navigationpage(
                    selectedIndex: 1,
                  )));
        },
        child: Icon(Icons.keyboard_return),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelPadding: EdgeInsets.all(0),
            controller: _tabController,
            dividerHeight: 0,
            labelColor: Colors.white,
            indicatorPadding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 0,
                      path: 'maizhenjieguo.png',
                      title: "総合結果")),

              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 1,
                      path: 'tizhibianshi.png',
                      title: "体質スコア分析")),
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 2,
                      path: 'jiankangpinggu.png',
                      title: "健康評価")),

              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 3,
                      path: 'liliaobaojian.png',
                      title: "理療保健")),
//------------------------------------------------------------------------------   1.   healplan          -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 4,
                      path: 'yinshijianyi.png',
                      title: "飲食\nアドバイス")),
//------------------------------------------------------------------------------   2.   Food and drink advice          -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 5,
                      path: 'yundongshenghuo.png',
                      title: "運動\nアドバイス")),
//------------------------------------------------------------------------------   3.   Exercise Advice           -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 6,
                      path: 'shenghuojianyi.png',
                      title: "養生\nアドバイス")),
//------------------------------------------------------------------------------   4.   Curing Advice           -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 7,
                      path: 'fenbumaixiang.png',
                      title: "脈象詳細")),
//------------------------------------------------------------------------------   5.   Pulse Elephant Detail           -------------------------------------

//------------------------------------------------------------------------------   6.   Complete knowledge of one's constitution          -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 8,
                      path: 'jingluofenxi.png',
                      title: "経絡解析")),
//------------------------------------------------------------------------------   7.   Health Evaluation          -------------------------------------
              Tab(
                  height: 80,
                  child: TabCard(
                      isSelected: _tabController.index == 9,
                      path: 'bagangbianzheng.png',
                      title: "八綱辨証")),
//------------------------------------------------------------------------------   8.   Eight-Principle Syndrome Differentiation          -------------------------------------

//------------------------------------------------------------------------------   9.   Health Plan          -------------------------------------

//------------------------------------------------------------------------------   10.   Health Plan          -------------------------------------
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Update TabBar when PageView changes
                setState(() {
                  _tabController.index = index;
                });
              },
              children: [
                UserPage(title: '総合結果'),
                BodyRecognization(title: '体質スコア分析'),
                HealthAssessment(title: '健康評価'),
                Physical_Health_Care(title: '理療保健'),
                FoodList(title: '飲食アドバイス'),
                ExerciseList(title: '運動アドバイス'),
                Wellness(title: '養生アドバイス'),
                PulseDetail(title: '脈象詳細'),
                MeridiansAnalysis(title: '経絡解析'),
                EightPrinciple(title: '八綱辨証'),
              ],
            ),
          ),
          SizedBox(height: 0,)
        ],
      ),
    ));
  }
}

class TabCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String path;
  const TabCard(
      {super.key,
      required this.isSelected,
      required this.title,
      required this.path});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 77,
        child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 52, 109, 214)
                  : const Color.fromARGB(255, 68, 171, 255),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/tabbar/$path',
                    width: 30, height: 30, fit: BoxFit.contain),
                Text(title, textAlign: TextAlign.center)
              ],
            )));
  }
}
