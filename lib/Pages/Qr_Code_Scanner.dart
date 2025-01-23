// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:url_launcher/url_launcher.dart';

// class QrCodeScanner extends StatefulWidget {
//   const QrCodeScanner({super.key});

//   @override
//   _QrCodeScannerState createState() => _QrCodeScannerState();
// }

// class _QrCodeScannerState extends State<QrCodeScanner> {
//   final MobileScannerController controller = MobileScannerController();
//   String qrCodeData = ''; // To store the scanned data
//   void pauseCamera() async {
//     await controller.pause();
//   }

//   void playCamera() async {
//     await controller.start();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Scanner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Mobile Scanner
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.6,
//               child: MobileScanner(
//                 controller: controller,
//                 onDetect: (BarcodeCapture capture) {
//                   final List<Barcode> barcodes = capture.barcodes;

//                   for (final barcode in barcodes) {
//                     // Store the first detected barcode data
//                     qrCodeData = barcode.displayValue!;
//                     if (qrCodeData != '') {
//                       pauseCamera();
//                       setState(() {
//                         qrCodeData = barcode.displayValue!;
//                       });
//                     }
//                     print('object');
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Display the QR code data if available
//             if (qrCodeData != '')
//               TextButton(
//                 onPressed: () async {
//                   final Uri uri = Uri.parse(qrCodeData);
//                   try {
//                     await launchUrl(uri);
//                   } catch (e) {
//                     throw Exception('Could not launch $e');
//                   }
//                   playCamera();
//                   setState(() {
//                     qrCodeData = '';
//                   });
//                 },
//                 child: Text(
//                   qrCodeData,
//                   style: TextStyle(fontSize: 16, color: Colors.blue),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
