import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/screens/home/badge_details.dart';

import 'package:scout_tracker/services/database.dart';

class Badges extends StatefulWidget {
  final Function showDrawer;
  Badges({Key key, this.showDrawer}) : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  List<String> badgeList = [];

  List<String> eagleList = [];

  bool eagleOnly = false;

  Future<void> _setBadgeLists() async {
    String text = await rootBundle.loadString('data/badge_list.txt');
    badgeList = LineSplitter().convert(text);
    badgeList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    // badgeSearchList = List.from(badgeList);
    text = await rootBundle.loadString('data/eagle_list.txt');
    eagleList = LineSplitter().convert(text);
    return true;
  }

  int _currentFilterIndex = 0;
  Map<String, Widget> _filters = {
    'All': Icon(
      Icons.all_inclusive,
      // color: Colors.black,
    ),
    'In Progress': Icon(
      Icons.hourglass_empty,
      // color: Colors.amberAccent,
    ),
    'Completed': Icon(
      Icons.check,
      // color: Colors.greenAccent,
    ),
    'Not Started': Icon(
      Icons.clear,
      // color: Colors.redAccent,
    ),
  };

  Widget _buildBadgeTile(String badgeName, double progress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4, // soften the shadow
              spreadRadius: 1, //extend the shadow
              offset: Offset(
                0, // Move to right 10  horizontally
                2, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            child: InkWell(
              splashColor: Colors.redAccent[100],
              highlightColor: Colors.grey.withOpacity(0.15),
              // When the user taps the button, show a snackbar.
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => BadgeDetails(
                      badgeName: badgeName,
                    ),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 200),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Image.asset(
                          'assets/images/badges/${badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '')}.png',
                          errorBuilder: (context, error, stackTrace) {
                        print(error.toString());
                        return Icon(Icons.not_interested);
                      }),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          badgeName,
                          maxLines: 2,
                          wrapWords: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Flexible(
                      child: LinearPercentIndicator(
                        percent: progress,
                        lineHeight: 10,
                        linearGradient: new LinearGradient(
                          colors: [
                            Colors.amber[200],
                            Colors.redAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        backgroundColor: Colors.grey[200],
                        clipLinearGradient: true,
                        trailing: Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '${(progress * 100).truncate()}%',
                            style: TextStyle(
                                color: Colors.redAccent[100],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(String filter, [Map filteredList]) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(30),
          // borderRadius: BorderRadius.only(
          //     topRight: Radius.circular(50),
          //     topLeft: Radius.circular(50)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: (() {
              if (filteredList == null || (filteredList?.isEmpty ?? true)) {
                return Container(
                  constraints: BoxConstraints.expand(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Text(
                        (() {
                          switch (filter) {
                            case 'In Progress':
                              return 'No Badges In Progress';
                              break;
                            case 'Completed':
                              return 'No Badges Completed';
                              break;
                            case 'Not Started':
                              return 'All Badges Complete';
                              break;
                            default:
                              return 'Could Not Retrive Badges';
                              break;
                          }
                        }()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return GridView.count(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 0.85,
                  //todo combine badgeSearchList with filteredbadgelist
                  children: (eagleOnly
                          ? badgeList.where(
                              (badgeName) => eagleList.contains(badgeName))
                          : badgeList)
                      .where((badgeName) => filteredList.containsKey(badgeName
                          .toLowerCase()
                          .replaceAll(' ', '-')
                          .replaceAll(',', '')))
                      .map<Widget>(
                        (badgeName) => _buildBadgeTile(
                            badgeName,
                            filteredList[badgeName
                                    .toLowerCase()
                                    .replaceAll(' ', '-')
                                    .replaceAll(',', '')]
                                .toDouble()),
                      )
                      .toList(),
                );
              }
            }())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        // leading: IconButton(
        //     icon: Icon(Icons.menu), onPressed: widget.showDrawer()),
        backgroundColor: Colors.white,
        title: DropdownButtonHideUnderline(
          child: DropdownButton(
            iconEnabledColor: Colors.redAccent[100],
            value: _currentFilterIndex,
            items: _filters.keys.map((filter) {
              return DropdownMenuItem(
                value: _filters.keys.toList().indexOf(filter),
                child: Text(
                  filter,
                  style: TextStyle(
                      color: _currentFilterIndex ==
                              _filters.keys.toList().indexOf(filter)
                          ? Colors.redAccent[100]
                          : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => _currentFilterIndex = val),
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                'Eagle Only',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              Switch(
                activeColor: Colors.redAccent[100],
                value: eagleOnly,
                onChanged: (bool selected) {
                  setState(() {
                    eagleOnly = !eagleOnly;
                  });
                },
              ),
            ],
          ),
        ],
      ),

      // flexibleSpace:
      //     child: Align(
      //         alignment: Alignment.bottomCenter,
      //         child: RaisedButton(onPressed: () {})),
      //   ),
      //   // child: Column(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   crossAxisAlignment: CrossAxisAlignment.center,
      //   //   children: <Widget>[
      //   //     Container(
      //   //         margin: EdgeInsets.only(top: 16.0),
      //   //         padding: EdgeInsets.only(left: 32.0, right: 32.0),
      //   //         child: Text(
      //   //           'Some text',
      //   //           textAlign: TextAlign.center,
      //   //           style: TextStyle(
      //   //               color: Colors.white,
      //   //               fontFamily: 'PlayfairDisplay',
      //   //               fontStyle: FontStyle.italic,
      //   //               fontSize: 16.0),
      //   //         )),
      //   //     Container(
      //   //         margin: EdgeInsets.only(top: 16.0),
      //   //         padding: EdgeInsets.only(left: 32.0, right: 32.0),
      //   //         child: Text(
      //   //           'some text',
      //   //           textAlign: TextAlign.center,
      //   //           style: TextStyle(
      //   //               color: Colors.white,
      //   //               fontFamily: 'PlayfairDisplay',
      //   //               fontSize: 16.0),
      //   //         )),
      //   //   ],
      //   // ),
      // ),

      body: FutureBuilder(
        future: _setBadgeLists(),
        builder: (context, snapshot) => snapshot.hasData
            ? StreamBuilder(
                stream: DatabaseService(uid: uid).user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map data = Map.from(snapshot.data['badge_progress']);
                    Map filteredBadges = {};
                    if (_currentFilterIndex == 0) {
                      filteredBadges = data;
                    } else if (_currentFilterIndex == 1) {
                      data.forEach((key, value) {
                        if (value > 0 && value < 1)
                          filteredBadges.addAll({key: value});
                      });
                    } else if (_currentFilterIndex == 2) {
                      data.forEach((key, value) {
                        if (value == 1) filteredBadges.addAll({key: value});
                      });
                    } else {
                      data.forEach((key, value) {
                        if (value == 0) filteredBadges.addAll({key: value});
                      });
                    }

                    return _buildBadges(
                        _filters.keys.toList().elementAt(_currentFilterIndex),
                        filteredBadges);
                  } else {
                    return Container();
                  }
                },
              )
            : Container(),
      ),
    );
  }
}
