import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:pulse_diagnosis/globaldata.dart';

void console(List<dynamic> params) {
  for (var param in params) {
    log('$param =========================================');
  }
}

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

Future<bool> addPatient(String number, String token, String email, String name,
    String gender, String birth, String phone, String address) async {
  try {
    final headers = {
      "token": '$token',
      'Content-Type': 'application/json',
    };

    final data =
        '{"number": "$number", "email": $email, "name": $name, "gender": $gender, "birth": $birth, "phone": $phone, "address": $address}';

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

Future<String> getAll(String token, String email) async {
  try {
    final headers = {
      'token': token,
      'Content-Type': 'application/json',
    };

    final data = '{"current": 1, "size": 10, "params": {"email":"ddd@ddd"}}';
    // final data = '{"current": 1, "size": 10, "params": {"email":$email}}';

    final url = Uri.parse(
        'http://mzy-jp.dajingtcm.com/double-ja/business/pulse/result/patient/paging/all');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
    await globalData.updatePatientResult(jsonResponse);
    console([jsonResponse]);
    return jsonResponse['msg'];
  } catch (e) {
    return e.toString();
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
    await globalData.updatePulseResult(jsonResponse['data']);
    const encoder = JsonEncoder.withIndent('  ');
    // log(encoder.convert(jsonResponse));
    return jsonResponse['msg'];
  } catch (e) {
    return e.toString();
  }
}

Future<void> initUserData(
    String email,
    String uid,
    String name,
    String password,
    String phone,
    String address,
    String gender,
    String birth) async {
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    await globalData.updatePatientDetail(
        uid, email, name, address, gender, birth, phone);
    final auth = FirebaseAuth.instance;
    await database.collection("Users").doc(auth.currentUser?.uid).set({
      "uid": auth.currentUser?.uid,
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "address": address,
      "gender": gender,
      "birth": birth,
      'registered': false,
    }, SetOptions(merge: true));
    return;
  } on FirebaseAuthException {
    return null;
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>?> getUserData() async {
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

    // Query the data subcollection for the user and get the document IDs (visit dates)
    QuerySnapshot snapshot = await firestore
        .collection('Users')
        .doc(uid) // Replace with the actual user ID
        .collection('data') // The subcollection containing the visits
        .get();

    // Extract visit dates (document IDs) from the query result
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

addDataToFirebase(String token) async {
  await getAll(token, globalData.email);
  while (globalData.patientResult.isEmpty) {
    await Future.delayed(Duration(milliseconds: 100));
  }
  if (globalData.patientResult.isNotEmpty) {
    int id =
        await globalData.patientResult['data']['records'][0]['id'];
    await getDetails(id, token);
    String visitDate =
        globalData.pulseResult["visitInfo"]["visitTime"].split(" ")[0];
    await saveVisitData(globalData.uid, visitDate, globalData.pulseResult);
  }
}
