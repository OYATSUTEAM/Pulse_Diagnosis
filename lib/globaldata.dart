import 'dart:ui';

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();
  factory GlobalData() {
    return _instance;
  }
  GlobalData._internal();

  Map<String, dynamic> pulseResult = {};
  Map<String, dynamic> patientResult = {};
  double s_width = 0.0;
  double s_height = 0.0;
  String currentLocal = 'ja';
  String uid = 'default',
      email = '',
      name = '',
      address = '',
      gender = '',
      age = '',
      phone = '';
  // updatePulseResult(Map<String, dynamic> _pulseResult) async {
  //   pulseResult = _pulseResult;
  // }

  updateCurrentLocal(String _local) async {
    currentLocal = _local;
  }

  // updatePatientResult(Map<String, dynamic> _patientResult) async {
  //   patientResult = _patientResult;
  // }

  updatePatientDetail(String _uid, String _email, String _name, String _gender,
      String _age, String _phone) async {
    uid = _uid;
    email = _email;
    name = _name;
    gender = _gender;
    age = _age;
    phone = _phone;
  }

  updateProfile(String _name, String _age, String _gender) async {
    name = _name;
    gender = _gender;
    age = _age;
  }

  updateS_Size(Size size) async {
    s_width = size.width;
    s_height = size.height;
  }
}

// Create a single instance
final globalData = GlobalData();
