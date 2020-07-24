import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeDetails extends StatefulWidget {
  final String badgeName;

  BadgeDetails({this.badgeName});

  @override
  _BadgeDetailsState createState() => _BadgeDetailsState();
}

class _BadgeDetailsState extends State<BadgeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.badgeName),
      ),
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: widget.badgeName,
              child: SvgPicture.asset(
                'assets/images/badges/${widget.badgeName.toLowerCase().replaceAll(' ', '-')}.svg',
                height: 70,
                placeholderBuilder: (context) => Center(
                  child: SpinKitDoubleBounce(
                    color: Colors.redAccent[100],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
