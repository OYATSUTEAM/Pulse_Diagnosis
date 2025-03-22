import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:pulse_diagnosis/globaldata.dart';
import 'package:easy_localization/easy_localization.dart';
class QrcodeForSignin extends StatefulWidget {
  const QrcodeForSignin({super.key});

  @override
  _QrcodeForSigninState createState() => _QrcodeForSigninState();
}

class _QrcodeForSigninState extends State<QrcodeForSignin> {
  final MobileScannerController controller = MobileScannerController();
  String number = '';
  bool isAdded = false;
  void pauseCamera() async {
    await controller.pause();
  }

  void playCamera() async {
    await controller.stop();
    await controller.start();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Scan QrCode'.tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mobile Scanner
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: MobileScanner(
                controller: controller,
                onDetect: (BarcodeCapture capture) {
                  final List<Barcode> barcodes = capture.barcodes;

                  if (barcodes.isNotEmpty) {
                    final barcodeValue = barcodes.first.displayValue;
                    if (barcodeValue != null && barcodeValue.isNotEmpty) {
                      pauseCamera();
                      setState(() {
                        number = barcodeValue;
                      console([number]);
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            if (number != '')
              TextButton(
                onPressed: () async {
                  if (!isAdded) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Center(child: CircularProgressIndicator());
                        });
                    String token = await getToken(number);
                    console([globalData.email, globalData.uid]);

                    final _isAdd = await addPatient(
                        number,
                        token,
                        globalData.email,
                        globalData.name,
                        globalData.gender,
                        globalData.birth,
                        globalData.phone,
                        globalData.address);
                    if (mounted) {
                      Navigator.pop(context);
                      setState(() {
                        isAdded = _isAdd;
                      });
                      await SignIntoPulse(globalData.uid);
                      if (mounted) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyHomePage();
                        }));
                      }
                    }
                  }
                },
                child: Text(isAdded ? 'connected' : 'connect',
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              ),
          ],
        ),
      ),
    );
  }
}
