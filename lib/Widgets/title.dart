import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset('assets/images/title.png', width: 150, height: 40),
            Positioned(
                child: Text(title, style: TextStyle(color: Colors.white))),
          ],
        )
      ],
    );
  }
}
