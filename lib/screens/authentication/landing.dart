import 'package:flutter/material.dart';
import 'package:scout_tracker/screens/authentication/login_form.dart';
import 'package:scout_tracker/screens/authentication/register_form.dart';
import 'package:scout_tracker/shared.dart';
import 'dart:math' as math;

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final List<Widget> _tabs = [
    LoginForm(),
    RegisterForm(),
  ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) =>  _moveClouds());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              backgroundGradient(context),
              //build body

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height / 3.5),
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                            'assets/images/general/landing_logo_day.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Scout Tracker',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              letterSpacing: 1,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 48),
                        child: _buildTabBar(),
                      ),
                      Expanded(
                        child: TabBarView(children: _tabs),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white24),
      child: Center(
        child: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.redAccent[100],
          labelStyle: TextStyle(
              fontSize: 20,
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.bold),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          tabs: [
            Tab(text: 'Login'),
            Tab(text: 'Register'),
          ],
        ),
      ),
    );
  }
}

/*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ChoiceChip(
                pressElevation: 0,
                selected: _currentIndex == 0,
                onSelected: (_) => setState(() => _currentIndex = 0),
                backgroundColor: Colors.white,
                selectedColor: Colors.redAccent[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                label: Text(
                  'Login',
                  style: TextStyle(
                      color: _currentIndex == 0 ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ChoiceChip(
                pressElevation: 0,
                selected: _currentIndex == 1,
                onSelected: (_) {
                  setState(() => _currentIndex = 1);
                },
                backgroundColor: Colors.transparent,
                selectedColor: Colors.redAccent[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                label: Text(
                  'Register',
                  style: TextStyle(
                      color: _currentIndex == 1 ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),*/
