import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:scout_tracker/models/badge_requirements.dart';

class BadgeView extends StatefulWidget {
  final BadgeRequirementList badgeRequirementList;
  final Function(bool) setChangesSaved;
  BadgeView({this.badgeRequirementList, this.setChangesSaved});

  @override
  _BadgeViewState createState() => _BadgeViewState();
}

class _BadgeViewState extends State<BadgeView> {
  BadgeRequirementList badgeRequirementList;
  String alphabet = 'abcdefghijklmnopqrstuvwxyz';

  Column _buildBadgeRequirementCards(BadgeRequirementList badgeRequirements) {
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //checkbox
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$newID.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    (() {
                      if (req.isCheckable) {
                        return CircularCheckBox(
                            inactiveColor: Colors.redAccent[100],
                            activeColor: Colors.greenAccent,
                            checkColor: Colors.white,
                            value: req.isComplete,
                            onChanged: (bool newValue) {
                              setState(() => req.setIsComplete(newValue));
                              widget.setChangesSaved(false);
                            });
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
                              '${req.subReqs.numChildrenCompleted} / ${req.subReqs.numChildrenRequired}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    }()),
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
                    child: _buildBadgeRequirementCards(req.subReqs),
                  ),
          ],
        ),
      );
    });
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: cards);
  }

  @override
  void initState() {
    badgeRequirementList = widget.badgeRequirementList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
            child: Column(
              children: [
                _buildBadgeRequirementCards(badgeRequirementList),
                badgeRequirementList.note == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
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
        ),
      ),
    );
  }
}
