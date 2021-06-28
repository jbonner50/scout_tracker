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
  final List<String> badgeList;
  final List<String> eagleList;
  Badges({Key key, this.showDrawer, this.badgeList, this.eagleList})
      : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  bool eagleOnly = false;

  int _currentFilterIndex = 0;
  Map<String, Widget> _progressIndicators = {
    'All': Icon(
      Icons.all_inclusive,
      // color: Colors.black,
    ),
    'In Progress': Icon(
      Icons.hourglass_full, color: Colors.amberAccent,
      // color: Colors.amberAccent,
    ),
    'Completed': Icon(
      Icons.check_circle, color: Colors.greenAccent,
      // color: Colors.greenAccent,
    ),
    'Not Started': Icon(
      Icons.cancel, color: Colors.redAccent,
      // color: Colors.redAccent,
    ),
  };

  Widget _buildBadgeListTile(String badgeName, double progress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: EdgeInsets.all(8),
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
                  1, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: ListTile(
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
            leading: Hero(
              tag: badgeName,
              child: Image.asset(
                  'assets/images/badges/${badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '')}.png',
                  errorBuilder: (context, error, stackTrace) {
                print(error.toString());
                return Icon(
                  Icons.not_interested,
                  color: Colors.grey[200],
                );
              }),
            ),
            title: AutoSizeText(
              badgeName,
              maxLines: 1,
              wrapWords: false,
              style: TextStyle(fontSize: 20),
            ),
            trailing: (() {
              if (progress == 1) {
                return _progressIndicators['Completed'];
              } else if (progress == 0.5) {
                return _progressIndicators['In Progress'];
              } else {
                return Icon(Icons.not_interested, color: Colors.transparent);
              }
            }()),
          )),
    );
  }

  Widget _buildBadges(String filter, [Map filteredList]) {
    return SafeArea(
      child: (() {
        if (filteredList == null || (filteredList?.isEmpty ?? true)) {
          return Center(
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
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
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
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  //todo combine badgeSearchList with filteredbadgelist
                  children: (eagleOnly ? widget.eagleList : widget.badgeList)
                      .where((badgeName) => filteredList.containsKey(badgeName
                          .toLowerCase()
                          .replaceAll(' ', '-')
                          .replaceAll(',', '')))
                      .map<Widget>(
                        (badgeName) => _buildBadgeListTile(
                            badgeName,
                            filteredList[badgeName
                                    .toLowerCase()
                                    .replaceAll(' ', '-')
                                    .replaceAll(',', '')]
                                .toDouble()),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        }
      }()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        // leading: IconButton(
        //     icon: Icon(Icons.menu), onPressed: widget.showDrawer()),
        backgroundColor: Colors.white,
        brightness: Brightness.light,

        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.menu,
            color: Colors.redAccent[100],
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: DropdownButtonHideUnderline(
          child: DropdownButton(
            iconEnabledColor: Colors.redAccent[100],
            value: _currentFilterIndex,
            items: _progressIndicators.keys.map((filter) {
              return DropdownMenuItem(
                value: _progressIndicators.keys.toList().indexOf(filter),
                child: Text(
                  filter,
                  style: TextStyle(
                      color: _currentFilterIndex ==
                              _progressIndicators.keys.toList().indexOf(filter)
                          ? Colors.redAccent[100]
                          : Colors.grey[700],
                      fontSize: 20,
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
                style: TextStyle(
                  color: Colors.redAccent[100],
                  fontWeight: FontWeight.bold,
                ),
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

      body: StreamBuilder(
        stream: DatabaseService(uid: uid).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = Map.from(snapshot.data['badge_progress']);
            Map filteredList = {};
            if (_currentFilterIndex == 0) {
              filteredList = data;
            } else if (_currentFilterIndex == 1) {
              data.forEach((key, value) {
                if (value > 0 && value < 1) filteredList.addAll({key: value});
              });
            } else if (_currentFilterIndex == 2) {
              data.forEach((key, value) {
                if (value == 1) filteredList.addAll({key: value});
              });
            } else {
              data.forEach((key, value) {
                if (value == 0) filteredList.addAll({key: value});
              });
            }

            return _buildBadges(
                _progressIndicators.keys
                    .toList()
                    .elementAt(_currentFilterIndex),
                filteredList);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
