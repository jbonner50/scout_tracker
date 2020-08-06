import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  Size size = mediaQueryData.size;
  double height = size.height;
  return Container(
    width: mediaQueryData.size.width,
    height: mediaQueryData.size.height,
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

Widget backgroundCustomGradient(context, height) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: height,
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
