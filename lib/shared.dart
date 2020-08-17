import 'package:flutter/material.dart';

Widget circle(double w, double h, Color c) {
  return Container(
    width: w,
    height: h,
    decoration: new BoxDecoration(
      color: c,
      shape: BoxShape.circle,
    ),
  );
}

Widget backgroundGradient(context) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width,
    height: size.height,
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          Colors.amber[200],
          Colors.redAccent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
}

Widget backgroundGradientWithCenterWidget(context, Widget centered) {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
    body: Container(
      width: size.width,
      height: size.height,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Colors.amber[200],
            Colors.redAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: centered),
    ),
  );
}
