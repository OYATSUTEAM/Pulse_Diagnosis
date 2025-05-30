import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer';
import 'dart:developer' as developer;

Future<void> saveUserData(UserData _userdata) async {
  final prefs = await SharedPreferences.getInstance();

  // Convert UserData to JSON string and save
  final jsonString = jsonEncode(_userdata.toJson());
  await prefs.setString('user_data', jsonString);
}

Future<void> saveEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_email_pulse', email);
}

Future<void> initUserData(String email, String uid, String name,
    String password, String phone, String gender, String age) async {
  FirebaseFirestore database = FirebaseFirestore.instance;
  try {
    // await globalData.updatePatientDetail(
    //     uid, email, name, address, gender, age, phone);
    final auth = FirebaseAuth.instance;
    final userData = UserData(
      email: email,
      uid: uid,
      name: name,
      password: password,
      phone: phone,
      gender: gender,
      age: age,
    );

   await saveUserData(userData);
    await database.collection("Users").doc(auth.currentUser?.uid).set({
      "uid": auth.currentUser?.uid,
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "gender": gender,
      "age": AggregateQuerySnapshot,
      'registered': false,
    }, SetOptions(merge: true));
    return;
  } on FirebaseAuthException {
    return null;
  } catch (e) {
    return null;
  }
}

Future<UserData?> getUserData() async {
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

Future<void> updatePulseResult(
    Map<String, dynamic> pulseData, String visitDate) async {
  final prefs = await SharedPreferences.getInstance();

  // Get existing pulse results or initialize empty list
  final String? existingData = prefs.getString('pulse_results');
  List<Map<String, dynamic>> pulseResults = [];

  if (existingData != null) {
    final List<dynamic> decoded = jsonDecode(existingData);
    pulseResults = decoded.cast<Map<String, dynamic>>();
  }

  // Add timestamp if not present
  if (!pulseData.containsKey('timestamp')) {
    pulseData['timestamp'] = visitDate;
  }

  // Add new result
  pulseResults.add(pulseData);

  // Save updated results
  await prefs.setString('pulse_results', jsonEncode(pulseResults));
}

Future<Map<String, dynamic>?> getPulseResult(String timestamp) async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('pulse_results');

  if (data == null) return null;

  final List<dynamic> pulseResults = jsonDecode(data);
  return pulseResults.firstWhere(
    (result) => result['timestamp'] == timestamp,
    orElse: () => null,
  );
}

Future<List<Map<String, dynamic>>> getAllPulseResults() async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('pulse_results');

  if (data == null) return [];

  final List<dynamic> decoded = jsonDecode(data);
  return decoded.cast<Map<String, dynamic>>();
}

Future<void> updatePatientResult(Map<String, dynamic> pulseData) async {
  final prefs = await SharedPreferences.getInstance();

  // Get existing pulse results or initialize empty list
  final String? existingData = prefs.getString('patient_results');
  List<Map<String, dynamic>> pulseResults = [];

  if (existingData != null) {
    final List<dynamic> decoded = jsonDecode(existingData);
    pulseResults = decoded.cast<Map<String, dynamic>>();
  }

  // Add new result
  pulseResults.add(pulseData);

  // Save updated results
  await prefs.setString('patient_results', jsonEncode(pulseResults));
}

Future<List<Map<String, dynamic>>> getPatientResult() async {
  final prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('patient_results');

  if (data == null) return [];

  final List<dynamic> decoded = jsonDecode(data);
  return decoded.cast<Map<String, dynamic>>();
}
