import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/badge_requirements.dart';
import 'package:scout_tracker/services/database.dart';
import 'package:scout_tracker/services/storage.dart';

class BadgeDetails extends StatefulWidget {
  final String badgeName;
  BadgeDetails({this.badgeName});

  @override
  _BadgeDetailsState createState() => _BadgeDetailsState();
}

class _BadgeDetailsState extends State<BadgeDetails> {
  BadgeRequirementList badgeRequirementList;

  String alphabet = 'abcdefghijklmnopqrstuvwxyz';
  Column _buildBadgeRequirementCards(BadgeRequirementList badgeRequirements,
      [bool test = false]) {
    List<Widget> cards = [];
    badgeRequirements.reqList.forEach((req) {
      List splitID = req.id.split(".");
      String newID = "";
      newID = splitID.length % 2 == 0
          ? String.fromCharCode(
              alphabet.codeUnitAt(int.parse(splitID[splitID.length - 1])) - 1)
          : splitID[splitID.length - 1];
      cards.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //checkbox

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$newID.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => req,
                      child: Consumer<BadgeRequirement>(
                        builder: (context, req, child) {
                          if (req.isCheckable) {
                            return CircularCheckBox(
                              inactiveColor: Colors.redAccent[100],
                              activeColor: Colors.greenAccent,
                              checkColor: Colors.white,
                              value: req.isComplete,
                              onChanged: (bool newValue) =>
                                  req.setIsComplete(newValue),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(left: 5),
                              constraints: BoxConstraints(minWidth: 60),
                              alignment: Alignment.centerLeft,
                              height: 50,
                              child: FilterChip(
                                pressElevation: 0,
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.redAccent[100],
                                selectedColor: Colors.greenAccent,
                                onSelected: (_) {},
                                selected: req.isComplete,
                                label: Text(
                                  '${req.subReqs.numChildrenComplete} / ${req.subReqs.numChildrenRequired}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          req.description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            req.subReqs == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 30),
                    child: _buildBadgeRequirementCards(req.subReqs, true),
                  ),
          ],
        ),
      );
    });
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: cards);
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,

      // body: Column(
      //     children: [
      //       Hero(
      //         tag: widget.badgeName,
      //         child: SvgPicture.asset(
      //           'assets/images/badges/${widget.badgeName.toLowerCase().replaceAll(' ', '-')}.svg',
      //           height: 70,
      //           placeholderBuilder: (context) => Center(
      //             child: SpinKitDoubleBounce(
      //               color: Colors.redAccent[100],
      //             ),
      //           ),
      //         ),
      //       ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topRight,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.amber[200],
                  Colors.redAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          shape: CircleBorder(),
                          height: 50,
                          color: Colors.white24,
                          elevation: 0,
                          highlightElevation: 0,
                          splashColor: Colors.redAccent[100],
                          highlightColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        Hero(
                          tag: widget.badgeName
                              .toLowerCase()
                              .replaceAll(' ', '-')
                              .replaceAll(',', ''),
                          child: Image.asset(
                              'assets/images/badges/${widget.badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '')}.png',
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                            print(error.toString());
                            return Icon(Icons.not_interested, size: 50);
                          }),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: AutoSizeText(
                            widget.badgeName,
                            maxLines: 1,
                            style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: MaterialButton(
                            onPressed: () {
                              DatabaseService(uid: uid)
                                  .updateRequirementListDocument(
                                      badgeRequirementList,
                                      widget.badgeName
                                          .toLowerCase()
                                          .replaceAll(' ', '-')
                                          .replaceAll(',', ''));
                              print('saved reqs');
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            height: 50,
                            color: Colors.white24,
                            elevation: 0,
                            highlightElevation: 0,
                            splashColor: Colors.redAccent[100],
                            highlightColor: Colors.transparent,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: DatabaseService(uid: uid).getBadgeData(widget
                        .badgeName
                        .toLowerCase()
                        .replaceAll(' ', '-')
                        .replaceAll(',', '')),
                    // DefaultAssetBundle.of(context)
                    //     .loadString('data/golf_v1.json'),
                    builder: (context, snapshot) {
                      return AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: (() {
                            if (snapshot.hasData) {
                              badgeRequirementList = snapshot.data;

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
                                  child: Column(
                                    children: [
                                      _buildBadgeRequirementCards(
                                          badgeRequirementList),
                                      badgeRequirementList.note == null
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  badgeRequirementList.note,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
