import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:pulse_diagnosis/Services/getData.dart';

class QrcodeGetNewData extends StatefulWidget {
  const QrcodeGetNewData({super.key});

  @override
  _QrcodeGetNewDataState createState() => _QrcodeGetNewDataState();
}

class _QrcodeGetNewDataState extends State<QrcodeGetNewData> {
  final MobileScannerController controller = MobileScannerController();
  String token = '';
  bool isAdded = false;
  void pauseCamera() async {
    await controller.pause();
  }

  void playCamera() async {
    await controller.stop();
    await controller.start();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QrCode to get new data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: MobileScanner(
                    controller: controller,
                    onDetect: (BarcodeCapture capture) async {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final barcodeValue = barcodes.first.displayValue;
                        if (barcodeValue != null && barcodeValue.isNotEmpty) {
                          pauseCamera();
                          setState(() {
                            token = barcodeValue;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              });
                          await addDataToFirebase(token);
                          if (mounted) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }
                        }
                      }
                    })),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
