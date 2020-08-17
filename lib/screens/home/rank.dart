import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/rank_requirements.dart';
import 'package:scout_tracker/services/database.dart';

class Rank extends StatefulWidget {
  // final String hyphenatedRankName;
  final RankRequirementList rankRequirementList;
  Rank({Key key, this.rankRequirementList}) : super(key: key);

  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Future _loadingRequirements;

  RankRequirementList rankRequirementListModel;
  String alphabet = 'abcdefghijklmnopqrstuvwxyz';

  Future<String> _showInitialsDialog() {
    String _initials;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 0),
          actionsPadding: EdgeInsets.only(right: 15),
          content: TextFormField(
            // autovalidate: _autoValidateEmail,
            // validator: (email) =>
            //     EmailValidator.validate(email) ? null : "Invalid email address",
            onChanged: (initials) => _initials = initials,
            style: TextStyle(fontSize: 24, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.person,
                size: 30,
                color: Colors.black,
              ),
              hintText: "Initials (eg. \"ERM\")",
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text(
                "Save",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(_initials.isEmpty ? null : _initials.toUpperCase());
              },
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        );
      },
    );
  }

  Column _buildRankRequirementCards(RankRequirementList rankRequirementList) {
    List<Widget> cards = [];
    rankRequirementList.reqList.forEach((req) {
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
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularCheckBox(
                                inactiveColor: Colors.redAccent[100],
                                activeColor: Colors.greenAccent,
                                checkColor: Colors.white,
                                value: req.isComplete,
                                onChanged: (bool newValue) async {
                                  if (!req.textbox) {
                                    if (newValue) {
                                      String initials =
                                          await _showInitialsDialog();
                                      if (initials != null) {
                                        setState(() {
                                          req.setInitials(initials);
                                          req.setIsComplete(newValue);
                                          req.setDate(DateTime.now());
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        req.setIsComplete(newValue);
                                        req.setInitials(null);
                                        req.setDate(null);
                                      });
                                    }
                                  } else {
                                    if (!newValue) {
                                      setState(() {
                                        req.setIsComplete(newValue);
                                        req.setText('');
                                      });
                                    }
                                  }
                                }),
                            req.initials != null
                                ? Text(req.initials)
                                : Container(),
                            req.date != null
                                ? Text(req.date.toString())
                                : Container(),
                          ],
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(left: 5),
                          constraints: BoxConstraints(minWidth: 60),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              req.description,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            if (req.textbox) ...[
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              TextFormField(
                                initialValue: req.text,
                                onChanged: (text) {
                                  setState(() {
                                    req.setText(text);
                                    req.setIsComplete(text.isNotEmpty);
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Text(
                                    'Entry: ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  hintText: "Edit data",
                                ),
                              )
                            ] else
                              Container(),
                          ],
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
                    child: _buildRankRequirementCards(req.subReqs),
                  ),
          ],
        ),
      );
    });
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: cards);
  }

  // @override
  // void initState() {
  //   // final String uid = Provider.of<String>(context, listen: false);
  //   // _loadingRequirements = widget.rankRequirementList;
  //   super.initState();
  // }

  @override
  void initState() {
    rankRequirementListModel = widget.rankRequirementList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildRankRequirementCards(rankRequirementListModel),
                rankRequirementListModel.note == null
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
                            rankRequirementListModel.note,
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
