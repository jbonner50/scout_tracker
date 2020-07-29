import 'dart:convert';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/badge_requirements.dart';

class BadgeDetails extends StatefulWidget {
  final String badgeName;

  BadgeDetails({this.badgeName});

  @override
  _BadgeDetailsState createState() => _BadgeDetailsState();
}

class _BadgeDetailsState extends State<BadgeDetails> {
  Column _buildBadgeRequirementCards(BadgeRequirementList badgeRequirements,
      [bool test = false]) {
    List<Widget> cards = [];
    badgeRequirements.reqList.forEach((req) {
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
                              margin: EdgeInsets.only(left: 5, right: 5),
                              constraints: BoxConstraints(minWidth: 60),
                              height: 50,
                              child: FilterChip(
                                pressElevation: 0,
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.redAccent[100],
                                selectedColor: Colors.greenAccent,
                                onSelected: (_) {},
                                selected:
                                    req?.subReqs?.subReqsComplete ?? false,
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

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${req.id}.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          color: Colors.white24,
                          elevation: 0,
                          highlightElevation: 0,
                          splashColor: Colors.redAccent[100],
                          highlightColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.badgeName,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString('data/golf.json'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> mappedJson =
                            json.decode(snapshot.data);
                        BadgeRequirementList badgeRequirements =
                            BadgeRequirementList.fromJson(mappedJson);
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
                            child:
                                _buildBadgeRequirementCards(badgeRequirements),
                          ),
                        );
                      } else {
                        return Container();
                      }
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
