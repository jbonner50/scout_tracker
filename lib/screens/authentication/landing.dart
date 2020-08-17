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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              backgroundGradient(context),
              //build body
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: _buildScoutPicture(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Scout Tracker',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              letterSpacing: 1,
                              color: Colors.white),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildTabBar(),
                      ),

                      Flexible(flex: 3, child: _buildTabBarView()),
                      // _buildTabBarView(),
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

  Widget _buildScoutPicture() {
    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            child: circle(120, 120, Colors.orange[700]),
            top: -40,
            left: -40,
          ),
          Positioned(
            child: circle(100, 100, Colors.orange),
            top: -30,
            left: -30,
          ),
          Positioned(
            top: 30,
            left: 290,
            height: 60,
            child: Image.asset(
              'assets/images/cloud.png',
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 55,
            left: 200,
            height: 60,
            child: Transform(
              transform: Matrix4.rotationY(math.pi),
              child: Image.asset(
                'assets/images/cloud.png',
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 370,
            top: 60,
            height: 200,
            child: Image.asset(
              'assets/images/tree.png',
            ),
          ),
          Positioned(
            top: 97,
            left: 410,
            height: 40,
            child: Transform(
              transform: Matrix4.rotationY(math.pi),
              child: Image.asset(
                'assets/images/bird.png',
              ),
            ),
          ),
          Positioned(
            left: 110,
            top: 50,
            width: 250,
            child: Image.asset(
              'assets/images/scout.png',
            ),
          ),
          Positioned(
            left: 145,
            top: 102,
            height: 200,
            child: Transform(
              transform: Matrix4.rotationY(math.pi),
              child: Image.asset(
                'assets/images/tent.png',
              ),
            ),
          ),
          Positioned(
            left: 320,
            top: 164,
            height: 100,
            child: Image.asset(
              'assets/images/campfire.png',
            ),
          ),
        ],
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
          labelColor: Colors.black,
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

  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        LoginForm(),
        RegisterForm(),
      ],
    );
  }
}
