import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/globaldata.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/category1.png',
                width: MediaQuery.of(context).size.width * 0.24),
            Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/category2.png',
                    width: MediaQuery.of(context).size.width * 0.24),
          ],
        ));
  }
}
