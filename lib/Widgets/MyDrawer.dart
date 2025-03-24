// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
// import 'package:pulse_diagnosis/Pages/QrCodes/QrCode_Get_New_Data.dart';
// import 'package:pulse_diagnosis/Pages/Results/About_Pulse.dart';
// import 'package:pulse_diagnosis/globaldata.dart';
// import 'package:easy_localization/easy_localization.dart';

// class Mydrawer extends StatefulWidget {
//   const Mydrawer({super.key});

//   @override
//   State<Mydrawer> createState() => _MydrawerState();
// }

// FirebaseAuth auth = FirebaseAuth.instance;

// class _MydrawerState extends State<Mydrawer> {
 

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//           width: MediaQuery.of(context).size.width * 0.4,
//           height: globalData.s_height,
//           child: Center(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                   onPressed: () async {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => QrcodeGetNewData()));
//                   },
//                   child: Text(
//                     'fetch new data'.tr(),
//                     style: TextStyle(fontSize: 19),
//                     textAlign: TextAlign.center,
//                   )),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         logOutConfirmationDialogue(context);
//                       },
//                       child: Row(
//                         children: [
//                           Text('logout'.tr(),
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.red)),
//                           Icon(Icons.logout, color: Colors.red)
//                         ],
//                       ))
//                 ],
//               ),
            
//             ],
//           ))),
//     );
//   }
// }
