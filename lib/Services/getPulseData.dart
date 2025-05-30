import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
// import 'dart:developer';
import 'dart:developer' as developer;

import 'package:pulse_diagnosis/globaldata.dart';

void console(List<dynamic> params) {
  for (var param in params) {
    developer.log('$param =========================================');
  }
}

String dd = 'OYATSUTEAM';
//=====================================================================              get number         =============================================================
Future<String> getNumber() async {
  try {
    final headers = {
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXJhbSI6IntcImlkXCI6NzIsXCJ0aW1lc3RhbXBcIjoxNzQxMzE1MTkwMzc5fSJ9.BSAA7Q8AHw0HaSFDqLE7AxdP6oLWVRpHbhG1FUCJpK8',
      'Content-Type': 'application/json',
    };

    final data = '{}';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/qrcode/patient/login/generate');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    return jsonResponse['msg'];
  } catch (e) {
    return e.toString();
  }
}

//=====================================================================              get token        =============================================================

Future<String> getToken(String number) async {
  try {
    final headers = {
      'Content-Type': 'application/json',
    };

    final data = '{"number": $number}';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/qrcode/patient/getToken');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    return jsonResponse['data']['token'];
  } catch (e) {
    return e.toString();
  }
}

String convertAgeToBirthDate(String age) {
  // Parse the age to an integer
  int ageInt = int.parse(age);

  // Get the current year
  int currentYear = DateTime.now().year;

  // Calculate the birth year
  int birthYear = currentYear - ageInt;

  // Create a date string in the format "YYYY-MM-DD"
  String birthDate = "$birthYear-1-1"; // January 1st

  return birthDate;
}

Future<bool> addPatient(
  String number,
  String token,
  String email,
  String name,
  String gender,
  String birth,
  String phone,
) async {
  try {
    final headers = {
      "token": token,
      'Content-Type': 'application/json',
    };

    final data =
        '{"number": "$number", "email": "$email", "name": "$name", "gender": "$gender", "birth": "${convertAgeToBirthDate(birth)}", "phone": "$phone", "address": ""}';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/qrcode/patient/add');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');
    // final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    return true;
  } catch (e) {
    return false;
  }
}

void onLongPressComplete(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: AlertDialog(
                title: Text(
              'こんにちは。\nこのアプリは、開発者の$ddさんとMYAKKOU.CO.LTD.の共同開発によるものです。',
              style: TextStyle(fontSize: 14),
            )),
          ));
  // Define your action here when long press is complete after 10 seconds
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(content: Text("こんにちは。このアプリは、開発者のMegahoshiさんとMYAKKOU.CO.LTD.の共同開発によるものです。")),
  // );
}

Future<int> getAll(String token, String email) async {
  try {
    final headers = {
      'token': token,
      'Content-Type': 'application/json',
    };
    // final data = '{"current": 1, "size": 10, "params": {"email":"ddd@ddd"}}';
    final data = '{"current": 1, "size": 10, "params": {"email":"$email"}}';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/pulse/result/patient/paging/all');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    final body = res.body;

    if (status != 200) throw Exception('http.post error: statusCode= $status');

    final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    await updatePatientResult(jsonResponse);
    List pulseResult = jsonResponse['data']['records'];
    return pulseResult.isNotEmpty ? 0 : 500;
  } catch (e) {
    return 500;
  }
}

Future<String> getDetails(int id, String token) async {
  try {
    final headers = {
      'token': token,
      'Content-Type': 'application/json',
    };

    final data = '{"id": $id }';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/pulse/result/patient/detail');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    await updatePulseResult(jsonResponse['data'], '');
    const encoder = JsonEncoder.withIndent('  ');
    developer.log(encoder.convert(jsonResponse));
    return jsonResponse['msg'];
  } catch (e) {
    return e.toString();
  }
}

Future<void> updateUserData(UserData _userdata) async {
  // globalData.updateProfile(name, age, gender);
  saveUserData(_userdata);
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    final auth = FirebaseAuth.instance;
    await database.collection("Users").doc(auth.currentUser?.uid).set({
      "name": _userdata.name,
      "gender": _userdata.gender,
      "age": _userdata.age,
    }, SetOptions(merge: true));
    return;
  } on FirebaseAuthException {
    return null;
  } catch (e) {
    return null;
  }
}

Future<void> updatePassword(String password) async {
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    final auth = FirebaseAuth.instance;
    await database.collection("Users").doc(auth.currentUser?.uid).set({
      "password": password,
    }, SetOptions(merge: true));
    return;
  } on FirebaseAuthException {
    return null;
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>?> getUserDataFromFirebase() async {
  try {
    FirebaseFirestore database = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      print("No user is currently logged in.");
      return null;
    }

    DocumentSnapshot snapshot =
        await database.collection("Users").doc(userId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      print("No user data found for this UID.");
      return null;
    }
  } catch (e) {
    print("Error getting user data: $e");
    return null;
  }
}

Future<bool> isSignIntoPulse(String uid) async {
  try {
    final userSnapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    bool isSignin = userSnapshot.get('registered');
    return isSignin;
  } catch (e) {
    return false;
  }
}

Future<bool> SignIntoPulse(String uid) async {
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    final userRef = database.collection("Users").doc(uid);
    await userRef.update({'registered': true});
    return true;
  } catch (e) {
    print("Error updating user: $e");
    return false;
  }
}

Future<void> saveVisitData(
    String uid, String visitDate, Map<String, dynamic> pulsedata) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('Users')
        .doc(uid) // Replace with the user's UID
        .collection('data')
        .doc(visitDate) // Use the visit date as document ID
        .set(pulsedata, SetOptions(merge: true));

    print("Data saved successfully!");
  } catch (e) {
    print("Error saving data: $e");
  }
}

Future<List<String>> getVisitDates(String uid) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firestore.collection('Users').doc(uid).collection('data').get();

    List<String> visitDates = snapshot.docs.map((doc) => doc.id).toList();

    return visitDates;
  } catch (e) {
    print("Error getting visit dates: $e");
    return [];
  }
}

Future<Map<String, dynamic>?> getVisitData(String uid, String visitDate) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch the specific visit document by visit date
    DocumentSnapshot snapshot = await firestore
        .collection('Users')
        .doc(uid) // Replace with the actual user ID
        .collection('data') // The subcollection containing the visits
        .doc(visitDate) // The visit date (document ID)
        .get();

    // Check if the document exists
    if (snapshot.exists) {
      // Return the data from the document
      return snapshot.data() as Map<String, dynamic>;
    } else {
      print("Visit data not found for visit date: $visitDate");
      return null;
    }
  } catch (e) {
    print("Error getting visit data: $e");
    return null;
  }
}

Future<int> isPulseFinished(String token) async {
  final status = await getAll(token, globalData.email);
  // final status = await getAll(token, "ddd@ddd");
  return status;
}

Future<String> addDataToFirebase(String token) async {
  List recordResult = globalData.patientResult['data']['records'];
  if (recordResult.isNotEmpty) {
    int id = await globalData.patientResult['data']['records'][0]['id'];
    await getDetails(id, token);
    String visitDate =
        globalData.pulseResult["visitInfo"]["visitTime"].split(" ")[0];
    await saveVisitData(globalData.uid, visitDate, globalData.pulseResult);
    return visitDate;
  } else {
    // Handle the case when 'data' does not exist
    return '';
  }
}
