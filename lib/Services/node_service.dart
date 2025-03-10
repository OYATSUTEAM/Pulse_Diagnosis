import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchQRCode() async {
  final url = Uri.parse('http://localhost:3000/generate-qrcode');

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('QR Code Data: ${data['data']}');
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Request failed: $e');
  }
}
