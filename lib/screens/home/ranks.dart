import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/rank_requirements.dart';
import 'package:scout_tracker/screens/home/rank.dart';
import 'package:scout_tracker/services/database.dart';

class Ranks extends StatefulWidget {
  final Function showDrawer;
  Ranks({Key key, this.showDrawer}) : super(key: key);

  @override
  _RanksState createState() => _RanksState();
}

class _RanksState extends State<Ranks> {
  int _currentRankIndex = 0;
  bool changesSaved = true;
  final List<String> rankNames = [
    'Scout',
    'Tenderfoot',
    'Second Class',
    'First Class',
    'Star',
    'Life',
    'Eagle',
  ];

  Map<String, Future<RankRequirementList>> rankFirestore;
  List<Future<Rank>> listFuturesRanks;
  Future<List<Rank>> futureListRanks;
  // Future<RankRequirementList> _currentRankReqList;

  Future<List<Rank>> listFuturesToFutureList(List<Future<Rank>> futures) async {
    List<Rank> list = [];
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
      return Rank(
          key: ValueKey(index++), rankRequirementList: await futureReqList);
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
                child: DropdownButton(
                  iconEnabledColor: Colors.redAccent[100],
                  value: _currentRankIndex,
                  items: rankNames.map((rankName) {
                    return DropdownMenuItem(
                      value: rankNames.indexOf(rankName),
                      child: Text(
                        rankName,
                        style: TextStyle(
                            color:
                                _currentRankIndex == rankNames.indexOf(rankName)
                                    ? Colors.redAccent[100]
                                    : Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentRankIndex = val),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    pressElevation: 0,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.redAccent[100],
                    selectedColor: Colors.greenAccent,
                    selected: changesSaved,
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
                      }
                    },
                    label: Text(
                      changesSaved ? 'Saved' : 'Save Changes',
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
