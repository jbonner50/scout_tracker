import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/screens/home/badge_details.dart';
import 'package:scout_tracker/screens/home/profile.dart';
import 'package:scout_tracker/services/database.dart';

enum BadgeList { all, inprogress, earned, unearned }

class Badges extends StatefulWidget {
  Badges({Key key}) : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  TextEditingController _searchController;

  List<String> badgeList = [];

  List<String> eagleList = [];

  List<String> badgeSearchList = [];
  bool eagleOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _setBadgeLists().then((result) => setState(() => badgeSearchList = result));
    // _searchController.addListener(() => onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future _setBadgeLists() async {
    String text = await rootBundle.loadString('data/badge_list.txt');

    badgeList = LineSplitter().convert(text);
    // badgeSearchList = List.from(badgeList);
    text = await rootBundle.loadString('data/eagle_list.txt');
    eagleList = LineSplitter().convert(text);
    badgeSearchList = List.from(badgeList);
    return badgeSearchList;
  }

  onSearchChanged(String query) {
    setState(() {
      badgeSearchList = (eagleOnly ? eagleList : badgeList)
          .where((string) => string.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Map<String, Widget> indicators = {
    'all': Icon(
      Icons.all_inclusive,
      // color: Colors.black,
    ),
    'inprogress': Icon(
      Icons.hourglass_empty,
      // color: Colors.amberAccent,
    ),
    'earned': Icon(
      Icons.check,
      // color: Colors.greenAccent,
    ),
    'unearned': Icon(
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        'assets/images/badges/${badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '')}.png',
                        height: 70, errorBuilder: (context, error, stackTrace) {
                      print(error.toString());
                      return Icon(Icons.not_interested, size: 50);
                    }),
                    Expanded(
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
                    SizedBox(height: 4),
                    LinearPercentIndicator(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(BadgeList type, [Map filteredBadges]) {
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
              if (filteredBadges == null || (filteredBadges?.isEmpty ?? true)) {
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
                          switch (type) {
                            case BadgeList.inprogress:
                              return 'No Badges In Progress';
                              break;
                            case BadgeList.earned:
                              return 'No Badges Earned';
                              break;
                            case BadgeList.unearned:
                              return 'No Badges Unearned';
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 0.85,
                  //todo combine badgeSearchList with filteredbadgelist
                  children: badgeSearchList
                      .where((badgeName) => filteredBadges.keys.contains(
                          badgeName
                              .toLowerCase()
                              .replaceAll(' ', '-')
                              .replaceAll(',', '')))
                      .map<Widget>(
                        (badgeName) => _buildBadgeTile(
                            badgeName,
                            filteredBadges[badgeName
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

    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              sliver: SliverAppBar(
                // forceElevated: value,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(30),
                ),
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Container(
                    padding: EdgeInsets.fromLTRB(24, 8, 16, 0),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: onSearchChanged,
                            style: TextStyle(fontSize: 25, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Badges",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  onSearchChanged("");
                                },
                                icon: Icon(Icons.clear, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Eagle',
                              style: TextStyle(fontFamily: 'ProductSans'),
                            ),
                            Text('Only',
                                style: TextStyle(fontFamily: 'ProductSans')),
                          ],
                        ),
                        Switch(
                          activeColor: Colors.redAccent[100],
                          value: eagleOnly,
                          onChanged: (bool selected) {
                            setState(() {
                              eagleOnly = !eagleOnly;
                            });
                            onSearchChanged(_searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[400],
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.bold),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.redAccent[100],
                      ),
                      tabs: [
                        Tab(icon: indicators['all']),
                        Tab(icon: indicators['inprogress']),
                        Tab(icon: indicators['earned']),
                        Tab(icon: indicators['unearned']),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
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
              Map all = {}, inprogress = {}, earned = {}, unearned = {};
              Map data = Map.from(snapshot.data['badge_progress']);
              data.forEach((key, value) {
                all.addAll({key: value});
                if (value == 0) {
                  unearned.addAll({key: value});
                } else if (value == 1) {
                  earned.addAll({key: value});
                } else if (value > 0 && value < 1) {
                  inprogress.addAll({key: value});
                }
              });

              return TabBarView(
                children: [
                  _buildBadges(BadgeList.all, all),
                  _buildBadges(BadgeList.inprogress, inprogress),
                  _buildBadges(BadgeList.earned, earned),
                  _buildBadges(BadgeList.unearned, unearned),
                ],
              );
            } else {
              return TabBarView(
                children: [
                  _buildBadges(BadgeList.all),
                  _buildBadges(BadgeList.inprogress),
                  _buildBadges(BadgeList.earned),
                  _buildBadges(BadgeList.unearned),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
