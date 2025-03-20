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
  String uid = '',
      email = '',
      name = '',
      address = '',
      gender = '',
      birth = '',
      phone = '';
  updatePulseResult(Map<String, dynamic> _pulseResult) async {
    pulseResult = _pulseResult;
  }

  updatePatientResult(Map<String, dynamic> _patientResult) async {
    patientResult = _patientResult;
  }

  updatePatientDetail(String _uid, String _email, String _name, String _address,
      String _gender, String _birth, String _phone) async {
    uid = _uid;
    email = _email;
    name = _name;
    address = _address;
    gender = _gender;
    birth = _birth;
    phone = _phone;
  }

  updateS_Size(Size size) async {
    s_width = size.width;
    s_height = size.height;
  }
}

// Create a single instance
final globalData = GlobalData();
