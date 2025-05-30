import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

Future<String?> getSavedEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('saved_email_pulse');
}

Future<String> getUserPassword(String uid) async {
  final DocumentSnapshot documentSnapshot;
  try {
    documentSnapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      return documentSnapshot.get('password');
    }
    return '123456';
  } catch (e) {
    print("Error fetching document: $e");
    return '123456';
  }
}
