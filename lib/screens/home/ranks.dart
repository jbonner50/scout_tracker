import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/rank_requirements.dart';
import 'package:scout_tracker/screens/home/rank_view.dart';
import 'package:scout_tracker/services/database.dart';

class Ranks extends StatefulWidget {
  final Function showDrawer;
  Ranks({Key key, this.showDrawer}) : super(key: key);

  @override
  _RanksState createState() => _RanksState();
}

class _RanksState extends State<Ranks> {
  int _currentRankIndex = 0;
  final List<String> rankNames = [
    'Scout',
    'Tenderfoot',
    'Second Class',
    'First Class',
    'Star',
    'Life',
    'Eagle',
  ];

  final List<bool> _changesSaved = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  void setChangesSaved(bool newValue) {
    print('worked');
    setState(() => _changesSaved[_currentRankIndex] = newValue);
  }

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

  Map<String, Future<RankRequirementList>> rankFirestore;
  List<Future<RankView>> listFuturesRanks;
  Future<List<RankView>> futureListRanks;
  // Future<RankRequirementList> _currentRankReqList;

  Future<List<RankView>> listFuturesToFutureList(
      List<Future<RankView>> futures) async {
    List<RankView> list = [];
    for (var future in futures) {
      list.add(await future);
    }
    return list;
  }

  @override
  void initState() {
    final String uid = Provider.of<String>(context, listen: false);
    Map<String, Future<RankRequirementList>> rankFirestore = Map.fromIterable(
        rankNames,
        key: (k) => k,
        value: (k) async => DatabaseService(uid: uid)
            .getRankData(k.toLowerCase().replaceAll(' ', '-')));
    int index = 0;
    listFuturesRanks = rankFirestore.values
        .map((Future<RankRequirementList> futureReqList) async {
      return RankView(
          key: ValueKey(index++),
          rankRequirementList: await futureReqList,
          setChangesSaved: setChangesSaved);
    }).toList();
    // futureListRanks = listFuturesToFutureList(listFuturesRanks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilt');
    final String uid = Provider.of<String>(context);
    // _currentRankReqList = DatabaseService(uid: uid).getRankData(rankNames
    //     .elementAt(_currentRankIndex)
    //     .toLowerCase()
    //     .replaceAll(' ', '-'));
    // print(rankNames.elementAt(_currentRankIndex));
    // final List<Rank> rankRequirements = [
    //   Rank(hyphenatedRankName: ranks[0].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[1].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[2].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[3].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[4].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[5].toLowerCase().replaceAll(' ', '-')),
    //   Rank(hyphenatedRankName: ranks[6].toLowerCase().replaceAll(' ', '-')),
    // ];
    return FutureBuilder(
      future: listFuturesRanks.elementAt(_currentRankIndex),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              // leading: IconButton(
              //     icon: Icon(Icons.menu), onPressed: widget.showDrawer()),
              backgroundColor: Colors.white,
              elevation: 0,
              title: DropdownButtonHideUnderline(
                child: StreamBuilder(
                    stream: DatabaseService(uid: uid).user,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map data = Map.from(snapshot.data['rank_progress']);
                        return DropdownButton(
                          iconEnabledColor: Colors.redAccent[100],
                          value: _currentRankIndex,
                          // selectedItemBuilder: (BuildContext context) {
                          //   return rankNames.map((String rankName) {
                          //     return Row(
                          //       // mainAxisSize: MainAxisSize.min,
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Text(
                          //           rankName,
                          //           style: TextStyle(
                          //               color: _currentRankIndex ==
                          //                       rankNames.indexOf(rankName)
                          //                   ? Colors.redAccent[100]
                          //                   : Colors.black,
                          //               fontSize: 24,
                          //               fontWeight: FontWeight.bold,
                          //               letterSpacing: 1),
                          //         ),
                          //         // SizedBox(width: 10),
                          //         Icon(
                          //           Icons.ac_unit,
                          //           color: Colors.blue,
                          //         ),
                          //       ],
                          //     );
                          //   }).toList();
                          // },
                          items: rankNames.map((rankName) {
                            double _progress = data[
                                    rankName.toLowerCase().replaceAll(' ', '-')]
                                .toDouble();

                            return DropdownMenuItem(
                              value: rankNames.indexOf(rankName),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    rankName,
                                    style: TextStyle(
                                        color: _currentRankIndex ==
                                                rankNames.indexOf(rankName)
                                            ? Colors.redAccent[100]
                                            : Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                  SizedBox(width: 10),
                                  (() {
                                    // print(_progress);
                                    if (_progress == 1) {
                                      return _progressIndicators['Completed'];
                                    } else if (_progress == 0.5) {
                                      return _progressIndicators['In Progress'];
                                    } else {
                                      return Container();
                                    }
                                  }()),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _currentRankIndex = val),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),

              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    pressElevation: 0,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.redAccent[100],
                    selectedColor: Colors.greenAccent,
                    selected: _changesSaved[_currentRankIndex],
                    onSelected: (newValue) async {
                      if (newValue) {
                        DatabaseService database = DatabaseService(uid: uid);
                        database
                            .updateRankDocument(
                                snapshot.data.rankRequirementList,
                                rankNames
                                    .elementAt(_currentRankIndex)
                                    .toLowerCase()
                                    .replaceAll(' ', '-'))
                            .whenComplete(() =>
                                database.updateRankProgressField(
                                    rankNames
                                        .elementAt(_currentRankIndex)
                                        .toLowerCase()
                                        .replaceAll(' ', '-')
                                        .replaceAll(',', ''),
                                    snapshot.data.rankRequirementList));
                        print(_currentRankIndex);
                        print('saved reqs');
                        setChangesSaved(true);
                      }
                    },
                    label: Text(
                      _changesSaved[_currentRankIndex] ? 'Saved' : 'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // body: Rank(rankRequirementList: snapshot.data),
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: snapshot.data,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
