import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_tracker/services/auth.dart';
import 'package:scout_tracker/services/database.dart';
import 'package:scout_tracker/shared.dart';
import 'dart:math';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _formKey = GlobalKey<FormState>();

  final List<String> ranks = [
    'Scout',
    'Tenderfoot',
    'Second Class',
    'First Class',
    'Star',
    'Life',
    'Eagle'
  ];
  String _firstName;
  String _lastName;
  int _rank = 0;
  int _troop;

  bool _isExpanded = false;

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

  Widget ellipse(double w, double h, Color c) {
    return Transform.rotate(
      angle: -pi / 4,
      child: Container(
        width: w,
        height: h,
        decoration: new BoxDecoration(
          color: c,
          borderRadius: BorderRadius.all(Radius.elliptical(w, h)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlue[100],
                        Colors.white,
                      ],
                      stops: [0, 0.2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        child: circle(120, 120, Colors.orange[700]),
                        top: -30,
                        left: -30,
                      ),
                      Positioned(
                        child: circle(100, 100, Colors.orange),
                        top: -20,
                        left: -20,
                      ),
                      Positioned(
                        child: Image.asset(
                          'assets/images/cloud.png',
                          color: Colors.white,
                          height: 60,
                        ),
                        top: 50,
                        right: 40,
                      ),
                      SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(80, 40, 80, 0),
                              child: Image.asset('assets/images/scout.png'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(height: 40),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Welcome',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 50,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Create your profile to continue',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 20,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            autofocus: false,
                                            decoration:
                                                textInputDecoration.copyWith(
                                              hintText: 'First',
                                            ),
                                            validator: (val) => val.isEmpty
                                                ? 'First Name Required'
                                                : null,
                                            onChanged: (val) => setState(
                                                () => _firstName = val),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            autofocus: false,
                                            decoration: textInputDecoration
                                                .copyWith(hintText: 'Last'),
                                            validator: (val) => val.isEmpty
                                                ? 'Last Name Required'
                                                : null,
                                            onChanged: (val) =>
                                                setState(() => _lastName = val),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Troop',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      autofocus: false,
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'NumbersOnly',
                                          prefix: Text('#  ')),
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Troop Number Required';
                                        } else if (int.parse(val) != null) {
                                          return 'Numbers Only';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (val) => setState(
                                          () => _troop = int.parse(val)),
                                    ),
                                    SizedBox(height: 15),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Rank',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _isExpanded = true),
                                      child: DropdownButtonFormField(
                                        decoration: textInputDecoration,
                                        isExpanded: _isExpanded,
                                        value: _rank,
                                        items: ranks.map((rank) {
                                          return DropdownMenuItem(
                                            value: ranks.indexOf(rank),
                                            child: Text(rank),
                                          );
                                        }).toList(),
                                        onChanged: (val) =>
                                            setState(() => _rank = val),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).primaryColor,
                                    Colors.orange,
                                  ])),
                              child: FlatButton(
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  print(_firstName);
                                  print(_lastName);
                                  print(_troop);
                                  print(_rank);
                                  dynamic result = await AuthService().signIn();
                                  String uid = result.uid;
                                  DatabaseService(uid: uid).updateUserData(
                                      _firstName, _lastName, _troop, _rank);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
