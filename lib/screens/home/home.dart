import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_tracker/screens/home/badges.dart';
import 'package:scout_tracker/screens/home/profile.dart';
import 'package:scout_tracker/screens/home/ranks.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scout_tracker/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // int _currentIndex = 0;
  // TabController _tabController;
  List<String> badgeList;
  List<String> eagleList;
  int _selectedIndex = 0;

  List<Widget> _tabs;

  void showDrawer() {
    print('test');
    Scaffold.of(context).openDrawer();
  }

  Future<void> _setBadgeLists() async {
    String text = await rootBundle.loadString('data/badge_list.txt');
    badgeList = LineSplitter().convert(text);
    badgeList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    // badgeSearchList = List.from(badgeList);
    text = await rootBundle.loadString('data/eagle_list.txt');
    eagleList = LineSplitter().convert(text);
    return true;
  }

  // @override
  // void initState() {
  //   // _tabController = TabController(length: 3, vsync: this);
  //   // _tabController.animation.addListener(() => _handleTabChange());

  //   super.initState();
  // }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  // void _handleTabChange() {
  //   if (!_tabController.indexIsChanging) {
  //     if ((_tabController.offset > 0.1 && _tabController.offset < 0.8) ||
  //         (_tabController.offset < -0.1 && _tabController.offset > -0.8)) {
  //       setState(() => _currentIndex = 99);
  //     } else {
  //       setState(() => _currentIndex = _tabController.animation.value.round());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text(
        //     'Profile',
        //     style: TextStyle(fontSize: 30),
        //   ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(15),
        //         bottomRight: Radius.circular(15)),
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.white12,
        // ),
        // appBar: AppBar(
        //   brightness: Brightness.dark,
        //   backgroundColor: Colors.transparent,
        //   bottom: PreferredSize(
        //     child: Container(
        //       height: 1,
        //       color: Colors.white60,
        //     ),
        //     preferredSize: Size.fromHeight(1.0),
        //   ),
        //   elevation: 0,
        //   title: Text(
        //     'Scout Tracker',
        //     style: TextStyle(
        //         fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1),
        //   ),
        // ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/general/scout_logo.png'),
                                fit: BoxFit.contain)),
                      ),
                      Text(
                        'Scout Tracker',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                      // letterSpacing: 1),
                    ),
                  ),
                  onTap: () => AuthService().logout(),
                ),
              ],
            ),
          ),
        ),
        body:
            // AnimatedSwitcher(
            //     duration: Duration(milliseconds: 200),
            //     child:
            FutureBuilder(
                future: _setBadgeLists().then((_) => [
                      Ranks(key: ValueKey(1), showDrawer: showDrawer),
                      Badges(
                        key: ValueKey(2),
                        showDrawer: showDrawer,
                        badgeList: badgeList,
                        eagleList: eagleList,
                      ),
                    ]),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? snapshot.data.elementAt(_selectedIndex)
                      : Container();
                }),

        // floatingActionButton: SpeedDial(
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.redAccent[100],
        //   overlayOpacity: 0,
        //   onClose: () => setState(() => _icon = Icon(
        //         Icons.add,
        //         key: ValueKey(1),
        //       )),
        //   onOpen: () => setState(() => _icon = Icon(
        //         Icons.close,
        //         key: ValueKey(2),
        //       )),
        //   child: AnimatedSwitcher(
        //     switchInCurve: Curves.ease,
        //     switchOutCurve: Curves.ease,
        //     transitionBuilder: (child, animation) =>
        //         ScaleTransition(child: child, scale: animation),
        //     duration: Duration(milliseconds: 150),
        //     child: _icon,
        //   ),
        //   animationSpeed: 300,
        //   curve: Curves.ease,
        //   children: [
        //     SpeedDialChild(
        //       label: 'Leadership Position',
        //       backgroundColor: Colors.white,
        //       foregroundColor: Colors.redAccent[100],
        //       child: Icon(Icons.people),
        //     ),
        //     SpeedDialChild(
        //       label: 'Camping Trip',
        //       backgroundColor: Colors.white,
        //       foregroundColor: Colors.redAccent[100],
        //       child: Transform.rotate(
        //         child: Icon(Icons.send),
        //         angle: -pi / 2,
        //       ),
        //     ),
        //     SpeedDialChild(
        //       label: 'Email Scoutmaster',
        //       backgroundColor: Colors.white,
        //       foregroundColor: Colors.redAccent[100],
        //       child: Icon(Icons.email),
        //     ),
        //   ],
        // ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          unselectedFontSize: 14,
          selectedFontSize: 14,
          selectedItemColor: Colors.redAccent[100],
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.keyboard_capslock), title: Text('Ranks')),
            BottomNavigationBarItem(
                icon: Icon(Icons.toll), title: Text('Badges')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.person_outline), title: Text('Profile')),
          ],
        )
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
        //     // gradient: new LinearGradient(
        //     //   colors: [
        //     //     Colors.amber[200],
        //     //     Colors.redAccent,
        //     //   ],
        //     //   begin: Alignment.topLeft,
        //     //   end: Alignment.bottomRight,
        //     // ),
        //   ),
        //   child: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       child: GNav(
        //           gap: 10,
        //           activeColor: Colors.white,
        //           color: Colors.grey[400],
        //           iconSize: 24,
        //           textStyle: TextStyle(fontSize: 20, color: Colors.white),
        //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //           duration: Duration(milliseconds: 800),
        //           tabBackgroundColor: Colors.redAccent,
        //           tabs: [
        //             GButton(
        //               icon: Icons.keyboard_capslock,
        //               text: 'Rank',
        //               backgroundGradient: LinearGradient(
        //                 colors: [
        //                   Colors.amber[200],
        //                   Colors.redAccent,
        //                 ],
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //               ),
        //             ),
        //             GButton(
        //               icon: Icons.toll,
        //               text: 'Badges',
        //               backgroundGradient: LinearGradient(
        //                 colors: [
        //                   Colors.amber[200],
        //                   Colors.redAccent,
        //                 ],
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //               ),
        //             ),
        //             GButton(
        //               icon: Icons.person_outline,
        //               text: 'Profile',
        //               backgroundGradient: LinearGradient(
        //                 colors: [
        //                   Colors.amber[200],
        //                   Colors.redAccent,
        //                 ],
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //               ),
        //             ),
        //           ],
        //           selectedIndex: _selectedIndex,
        //           onTabChange: (index) {
        //             setState(() {
        //               _selectedIndex = index;
        //             });
        //           }),
        //     ),
        //   ),
        // ),
        );

    // Container(
    //   height: 70,
    //   padding: EdgeInsets.all(10),
    //   color: Colors.white,
    //   child: TabBar(
    //     controller: _tabController,
    //     unselectedLabelColor: Colors.redAccent[100],
    //     labelStyle: TextStyle(
    //         color: Colors.white,
    //         fontSize: 20,
    //         fontFamily: 'ProductSans',
    //         fontWeight: FontWeight.bold),
    //     indicator: BoxDecoration(
    //       borderRadius: BorderRadius.circular(50),
    //       gradient: new LinearGradient(
    //           colors: [
    //             Colors.redAccent,
    //             Colors.amber[200],
    //           ],
    //           begin: Alignment.centerLeft,
    //           end: Alignment.centerRight,
    //           stops: [0, 1],
    //           tileMode: TileMode.clamp),
    //     ),
    //     onTap: (selectedIndex) {
    //       setState(() => _currentIndex = selectedIndex);
    //     },
    //     tabs: [
    //       Tab(
    //         child: AnimatedSwitcher(
    //           switchInCurve: Curves.easeIn,
    //           switchOutCurve: Curves.easeOut,
    //           transitionBuilder: (child, animation) =>
    //               ScaleTransition(child: child, scale: animation),
    //           duration: Duration(milliseconds: 200),
    //           child: _currentIndex == 0
    //               ? Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     Icon(
    //                       Icons.keyboard_capslock,
    //                       size: 25,
    //                     ),
    //                     Text('Rank'),
    //                   ],
    //                 )
    //               : Icon(
    //                   Icons.keyboard_capslock,
    //                   size: 30,
    //                 ),
    //         ),
    //       ),
    //       Tab(
    //         child: AnimatedSwitcher(
    //           switchInCurve: Curves.easeIn,
    //           switchOutCurve: Curves.easeOut,
    //           transitionBuilder: (child, animation) =>
    //               ScaleTransition(child: child, scale: animation),
    //           duration: Duration(milliseconds: 200),
    //           child: _currentIndex == 1
    //               ? Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     Icon(
    //                       Icons.toll,
    //                       size: 25,
    //                     ),
    //                     Text('Badges'),
    //                   ],
    //                 )
    //               : Icon(
    //                   Icons.toll,
    //                   size: 30,
    //                 ),
    //         ),
    //       ),
    //       Tab(
    //         child: AnimatedSwitcher(
    //           switchInCurve: Curves.easeIn,
    //           switchOutCurve: Curves.easeOut,
    //           transitionBuilder: (child, animation) =>
    //               ScaleTransition(child: child, scale: animation),
    //           duration: Duration(milliseconds: 200),
    //           child: _currentIndex == 2
    //               ? Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     Icon(
    //                       Icons.person_outline,
    //                       size: 25,
    //                     ),
    //                     Text('Profile'),
    //                   ],
    //                 )
    //               : Icon(
    //                   Icons.person_outline,
    //                   size: 30,
    //                 ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  }
}
