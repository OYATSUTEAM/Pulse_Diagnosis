import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pulse_diagnosis/Pages/HomePage.dart';
import 'package:pulse_diagnosis/Services/getData.dart';
import 'package:easy_localization/easy_localization.dart';

class QrcodeGetNewData extends StatefulWidget {
  const QrcodeGetNewData({super.key});

  @override
  _QrcodeGetNewDataState createState() => _QrcodeGetNewDataState();
}

class _QrcodeGetNewDataState extends State<QrcodeGetNewData> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
  );
  String token = '';
  bool isAdded = false;
  void pauseCamera() async {
    await controller.pause();
  }

  void playCamera() async {
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
      appBar: AppBar(title: Text('Scan QrCode'.tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: MobileScanner(
                    errorBuilder: (
                      BuildContext context,
                      MobileScannerException error,
                      Widget? child,
                    ) {
                      return ScannerErrorWidget(error: error);
                    },
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

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
