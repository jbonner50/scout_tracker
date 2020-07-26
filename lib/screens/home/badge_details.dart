import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scout_tracker/models/requirements.dart';

class BadgeDetails extends StatefulWidget {
  final String badgeName;

  BadgeDetails({this.badgeName});

  @override
  _BadgeDetailsState createState() => _BadgeDetailsState();
}

class _BadgeDetailsState extends State<BadgeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.badgeName),
      ),
      backgroundColor: Colors.redAccent[100],
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: widget.badgeName,
              child: SvgPicture.asset(
                'assets/images/badges/${widget.badgeName.toLowerCase().replaceAll(' ', '-')}.svg',
                height: 70,
                placeholderBuilder: (context) => Center(
                  child: SpinKitDoubleBounce(
                    color: Colors.redAccent[100],
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future:
                  DefaultAssetBundle.of(context).loadString('data/golf.json'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> mappedJson = json.decode(snapshot.data);
                  RequirementList badgeRequirements =
                      RequirementList.fromTemplate(mappedJson);
                  return RequirementTree(badgeRequirements: badgeRequirements);
                } else {
                  return Text('error');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class RequirementTree extends StatefulWidget {
  RequirementList badgeRequirements;
  RequirementTree({this.badgeRequirements});

  @override
  _RequirementTreeState createState() => _RequirementTreeState();
}

class _RequirementTreeState extends State<RequirementTree> {
  List<Widget> _buildRequirementCards(List<Requirement> reqList) {
    List<Widget> cards = [];
    reqList.forEach((req) {
      cards.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CheckboxListTile(
                    value: true,
                    onChanged: (newValue) {},
                    title: Text(req.description))
              ],
            ),
            req.subReqs == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRequirementCards(req.subReqs.reqList),
                    ),
                  )
          ],
        ),
      );
    });
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildRequirementCards(widget.badgeRequirements.reqList),
    );
  }
}
