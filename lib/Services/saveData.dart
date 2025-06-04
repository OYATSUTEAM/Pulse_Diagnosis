import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer';
import 'dart:developer' as developer;

Future<void> saveUserDataToLocal(UserData _userData) async {
  final prefs = await SharedPreferences.getInstance();

  // Convert UserData to JSON string and save
  final jsonString = jsonEncode(_userData.toJson());
  await prefs.setString('user_data', jsonString);
}

Future<void> saveEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_email_pulse', email);
}

Future<void> initUserDataToFirebase(UserData _userData) async {
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    final auth = FirebaseAuth.instance;
    await database.collection("Users").doc(auth.currentUser?.uid).set({
      "uid": _userData.uid,
      "email": _userData.email,
      "name": _userData.name,
      "password": _userData.password,
      "phone": _userData.phone,
      "gender": _userData.gender,
      "age": _userData.age,
      'registered': false,
    }, SetOptions(merge: true));
    return;
  } on FirebaseAuthException catch (e) {
    console([e, 'this is create account database error']);
    return null;
  } catch (e) {
    console([e, 'this is create account database error']);
    return null;
  }
}

Future<UserData?> getUserDataFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('user_data');

  if (jsonString == null) {
    return null;
  }

  try {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserData.fromJson(jsonMap);
  } catch (e) {
    developer.log('Error parsing user data: $e');
    return null;
  }
}

Future<void> updatePulseResult(Map<String, dynamic> pulseData) async {
  final prefs = await SharedPreferences.getInstance();

  // Save single pulse result
  await prefs.setString('pulse_results', jsonEncode(pulseData));
}

Future<Map<String, dynamic>?> getPulseResult() async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('pulse_results');

  if (data == null) return null;

  final Map<String, dynamic> decoded = jsonDecode(data);
  return decoded;
}

Future<List<Map<String, dynamic>>> getAllPulseResults() async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('pulse_results');

  if (data == null) return [];

  final List<dynamic> decoded = jsonDecode(data);
  return decoded.cast<Map<String, dynamic>>();
}

Future<void> updatePatientResult(Map<String, dynamic> patientResult) async {
  final prefs = await SharedPreferences.getInstance();

  // Save single patient result
  await prefs.setString('patient_results', jsonEncode(patientResult));
}

Future<Map<String, dynamic>?> getPatientResult() async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('patient_results');

  if (data == null) return null;

  final Map<String, dynamic> decoded = jsonDecode(data);
  return decoded;
}
