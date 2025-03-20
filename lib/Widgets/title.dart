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
            SizedBox(
              width: 150,
              height: 40,
              child: Positioned(child: Image.asset('assets/images/title.png')),
            ),
            Positioned(
                child: Text(title, style: TextStyle(color: Colors.white))),
          ],
        )
      ],
    );
  }
}
