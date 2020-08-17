import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/screens/authentication/landing.dart';
import 'package:scout_tracker/screens/home/home.dart';
import 'package:scout_tracker/services/storage.dart';
import 'package:scout_tracker/shared.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Widget _body;

  Future loadData() async {
    await rootBundle.loadString('data/badge_list.txt').then((text) {
      List badgeNames = LineSplitter().convert(text);
      StorageService().saveAllBadgesJson(badgeNames);
    });
    await StorageService().saveAllRanksJson();
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);
    print(uid);
    _body = backgroundGradient(context);

    if (uid == null) {
      setState(() => _body = Landing());
    } else if (uid != 'loading') {
      setState(
        () => _body = FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Home()
                  : backgroundGradientWithCenterWidget(
                      context,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Loading data',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                letterSpacing: 1,
                                color: Colors.white),
                          ),
                          SpinKitThreeBounce(color: Colors.white, size: 20),
                        ],
                      ));
            }),
      );
    }
    //loading = not received; null = no user; full uid = signed in
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        // top gradient
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topRight,
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
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: _body,
        ),
      ],
    );
  }
}
