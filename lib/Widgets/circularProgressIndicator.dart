import 'package:flutter/material.dart';

CirculatorIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => Center(
            child: CircularProgressIndicator(),
          ));
}
