import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pulse_diagnosis/Model/UserData.dart';
import 'package:pulse_diagnosis/Pages/Results/PulseResultPage.dart';
import 'package:pulse_diagnosis/Services/getPulseData.dart';
import 'package:pulse_diagnosis/Services/saveData.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

class QrcodeForSignin extends StatefulWidget {
  const QrcodeForSignin({super.key});

  @override
  _QrcodeForSigninState createState() => _QrcodeForSigninState();
}

class _QrcodeForSigninState extends State<QrcodeForSignin> {
  final MobileScannerController controller = MobileScannerController();
  String number = '';
  String visitDate = '';
  bool isRunningProgress = false;
  double overallProgress = 0.0;
  int pulseResult = 500;
  Timer? timer; // Timer to control progress updates
  bool isAdded = false;
  UserData userData = UserData(
      email: '',
      uid: '',
      name: '',
      password: '',
      phone: '',
      gender: '',
      age: '');
  void pauseCamera() async {
    await controller.pause();
  }

  void stopCamera() async {
    await controller.stop();
  }

  void playCamera() async {
    await controller.stop();
    await controller.start();
  }

  @override
  void initState() {
    _getInitialData();
    super.initState();
  }

  _getInitialData() async {
    UserData? _userData = await getUserDataFromLocal();
    if (_userData != null) {
      setState(() {
        userData = _userData;
      });
    }
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  Future<void> downloadAllAudioFiles() async {
    if (!isRunningProgress) {
      setState(() {
        isRunningProgress = true;
      });
      Duration duration = Duration(seconds: 2);
      const step = 0.01; // Increment step for progress
      var totalSteps =
          (duration.inSeconds * 50); // Total steps based on duration

      int currentStep = 0;
      timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
        if (currentStep <= totalSteps) {
          setState(() {
            overallProgress = (currentStep * step);
          });
          currentStep++;
        } else {
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('fetch pulse'.tr(),
            style: TextStyle(color: const Color.fromARGB(255, 0, 168, 154))),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            !isAdded
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (BarcodeCapture capture) async {
                        final List<Barcode> barcodes = capture.barcodes;

                        if (barcodes.isNotEmpty) {
                          final barcodeValue = barcodes.first.displayValue;
                          if (barcodeValue != null && barcodeValue.isNotEmpty) {
                            pauseCamera();
                            stopCamera();
                            String token = await getToken(barcodeValue);
                            final _isAdd = await addPatient(
                                barcodeValue,
                                token,
                                userData.email,
                                userData.name,
                                userData.gender,
                                userData.age,
                                userData.phone);
                            if (mounted) {
                              setState(() {
                                isAdded = _isAdd;
                              });
                            }
                          }
                        }
                      },
                    ),
                  )
                : CircularPercentIndicator(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    lineWidth: 8.0,
                    backgroundColor: Colors.white,
                    percent: overallProgress.clamp(0.0, 1.0),
                    center: overallProgress > 0.0
                        ? Text(
                            "${(overallProgress * 100).toStringAsFixed(1)}%",
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(''),
                    progressColor: const Color.fromARGB(255, 0, 168, 154),
                  ),
            if (isAdded)
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (isAdded) {
                        int _result = await isPulseFinished(
                            'bdcbdf10e6974ca19ac894537550b51e');
                        if (mounted) {
                          setState(() {
                            pulseResult = _result;
                          });
                        }
                        if (_result == 0) {
                          downloadAllAudioFiles();
                          String _visitDate = await addDataToFirebase(
                              'bdcbdf10e6974ca19ac894537550b51e');

                          if (mounted) {
                            setState(() {
                              visitDate = _visitDate;
                            });
                          }
                        }
                      }
                    },
                    child: Text('fetch new data'.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                  visitDate != ''
                      ? TextButton(
                          child: Text(visitDate,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 168, 154),
                                  fontSize: 24)),
                          onPressed: () {
                            if (mounted) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Pulseresultpage(
                                        visitDate: visitDate,
                                      )));
                            }
                          },
                        )
                      : Text(''),
                ],
              )
          ],
        ),
      ),
    );
  }
}
