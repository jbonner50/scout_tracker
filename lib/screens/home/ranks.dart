import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/rank_requirements.dart';
import 'package:scout_tracker/screens/home/rank.dart';
import 'package:scout_tracker/services/database.dart';

class Ranks extends StatefulWidget {
  Ranks({Key key}) : super(key: key);

  @override
  _RanksState createState() => _RanksState();
}

class _RanksState extends State<Ranks> {
  String currentRank;
  final List<String> rankNames = [
    'Scout',
    'Tenderfoot',
    'Second Class',
    'First Class',
    'Star',
    'Life',
    'Eagle',
  ];

  final List<Widget> rankIcons = [
    Icon(Icons.child_care),
    Icon(Icons.explore),
    Icon(Icons.looks_two),
    Icon(Icons.looks_one),
    Icon(Icons.star),
    Icon(Icons.favorite),
    Icon(Icons.brightness_high),
  ];

  Map<String, Future<RankRequirementList>> rankFirestore;
  List<Future<Rank>> listFuturesRanks;
  Future<List<Rank>> futureListRanks;

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
        value: (k) => DatabaseService(uid: uid)
            .getRankData(k.toLowerCase().replaceAll(' ', '-')));
    List<Future<Rank>> listFuturesRanks = rankFirestore.values
        .map((Future<RankRequirementList> futureReqList) async {
      return Rank(rankRequirementList: await futureReqList);
    }).toList();
    futureListRanks = listFuturesToFutureList(listFuturesRanks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilt');
    final String uid = Provider.of<String>(context);
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
      future: futureListRanks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 7,
            // initialIndex: ranks
            //     .map((name) => name.toLowerCase().replaceAll(' ', '-'))
            //     .toList()
            //     .indexOf(snapshot.data),
            child: Builder(
              builder: (BuildContext context) {
                final TabController _tabController =
                    DefaultTabController.of(context);
                currentRank = rankNames.elementAt(_tabController.index);
                _tabController.addListener(() {
                  if (!_tabController.indexIsChanging) {
                    setState(() => currentRank =
                        rankNames.elementAt(_tabController.index));
                  }
                });
                return NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        sliver: SliverAppBar(
                          automaticallyImplyLeading: false,
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
                                borderRadius:
                                    BorderRadiusDirectional.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    currentRank,
                                    style: TextStyle(
                                      fontSize: 30,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  MaterialButton(
                                    onPressed: () async {
                                      DatabaseService database =
                                          DatabaseService(uid: uid);
                                      database
                                          .updateRankDocument(
                                              snapshot.data
                                                  .elementAt(
                                                      _tabController.index)
                                                  .rankRequirementList,
                                              currentRank
                                                  .toLowerCase()
                                                  .replaceAll(' ', '-'))
                                          .whenComplete(() =>
                                              database.updateRankProgressField(
                                                  rankNames
                                                      .elementAt(
                                                          _tabController.index)
                                                      .toLowerCase()
                                                      .replaceAll(' ', '-')
                                                      .replaceAll(',', ''),
                                                  snapshot.data
                                                      .elementAt(
                                                          _tabController.index)
                                                      .rankRequirementList));

                                      print('saved reqs');
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: Colors.redAccent[100],
                                    elevation: 0,
                                    highlightElevation: 0,
                                    splashColor: Colors.white24,
                                    highlightColor: Colors.transparent,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
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
                                tabs: rankNames.map((name) {
                                  String hyphenatedRankName =
                                      name.toLowerCase().replaceAll(' ', '-');
                                  return Tab(
                                    child: Image.asset(
                                      'assets/images/ranks/$hyphenatedRankName.png',
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(children: snapshot.data),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
