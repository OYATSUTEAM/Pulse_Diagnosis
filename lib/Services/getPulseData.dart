import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Pages/Results/PulseResultPage.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
// import 'dart:developer';
import 'dart:developer' as developer;

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
    await updatePulseResult(jsonResponse['data']);
    const encoder = JsonEncoder.withIndent('  ');
    return jsonResponse['msg'];
  } catch (e) {
    return e.toString();
  }
}

Future<void> updateUserData(UserData _userdata) async {
  saveUserDataToLocal(_userdata);
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

Future<void> updatePasswordInFirebase(String password) async {
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

Future<UserData> getUserDataFromFirebase() async {
  UserData userData = UserData(
      email: '',
      uid: '',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');
  try {
    FirebaseFirestore database = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      print("No user is currently logged in.");
      return userData;
    }

    DocumentSnapshot snapshot =
        await database.collection("Users").doc(userId).get();

    if (snapshot.exists) {
      final _userData = snapshot.data() as Map<String, dynamic>;
      return UserData(
          email: _userData['email'],
          uid: _userData['uid'],
          name: _userData['name'],
          password: _userData['password'],
          phone: _userData['phone'],
          gender: _userData['gender'],
          age: _userData['age']);
    } else {
      print("No user data found for this UID.");
      return userData;
    }
  } catch (e) {
    print("Error getting user data: $e");
    return userData;
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

Future<String> saveVisitData(
    String uid, String visitDate, Map<String, dynamic> pulsedata) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String baseDocId = visitDate;
    String docId = '$baseDocId-1'; // Start with -1 suffix
    int counter =
        2; // Start counter from 2 since we're using -1 for first entry

    // Check if document exists and find next available number
    while (true) {
      DocumentSnapshot doc = await firestore
          .collection('Users')
          .doc(uid)
          .collection('data')
          .doc(docId)
          .get();

      if (!doc.exists) {
        break;
      }
      docId = '$baseDocId-$counter';
      counter++;
    }

    // Save with the new document ID
    await firestore
        .collection('Users')
        .doc(uid)
        .collection('data')
        .doc(docId)
        .set(pulsedata, SetOptions(merge: true));
    print("Data saved successfully with ID: $docId");
    return docId;
  } catch (e) {
    print("Error saving data: $e");
    return '';
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
  UserData? _userData = await getUserDataFromLocal();
  if (_userData != null) {
    final status = await getAll(token, _userData.email);
    return status;
  }
  return 500;
}

Future<String> addDataToFirebase(String token) async {
  Map<String, dynamic>? patientResult = await getPatientResult();
  UserData? userData = await getUserDataFromLocal();
  if (patientResult == null || userData == null) {
    return '';
  }

  List recordResult = patientResult['data']['records'];
  if (recordResult.isNotEmpty) {
    int id = await patientResult['data']['records'][0]['id'];
    await getDetails(id, token);
    Map<String, dynamic>? pulseResult = await getPulseResult();
    if (pulseResult == null) return '';
    String visitDate = pulseResult["visitInfo"]["visitTime"].split(" ")[0];
    final _visitDate =
        await saveVisitData(userData.uid, visitDate, pulseResult);
    // await saveVisitData(userData.uid, visitDate, patientResult);
    return _visitDate;
  } else {
    // Handle the case when 'data' does not exist
    return '';
  }
}
