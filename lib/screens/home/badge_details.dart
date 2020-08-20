import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/badge_requirements.dart';
import 'package:scout_tracker/screens/home/badge_view.dart';
import 'package:scout_tracker/services/database.dart';
import 'package:scout_tracker/services/storage.dart';

class BadgeDetails extends StatefulWidget {
  final String badgeName;
  BadgeDetails({this.badgeName});

  @override
  _BadgeDetailsState createState() => _BadgeDetailsState();
}

class _BadgeDetailsState extends State<BadgeDetails> {
  bool _changesSaved;

  void setChangesSaved(bool newValue) {
    setState(() => _changesSaved = newValue);
  }

  String alphabet = 'abcdefghijklmnopqrstuvwxyz';

  Future _showSaveDialog(
      String uid, BadgeRequirementList badgeRequirementList) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 0),
          actionsPadding: EdgeInsets.only(right: 15),
          content: Text(
            'Save Changes?',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text(
                "No",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                DatabaseService database = DatabaseService(uid: uid);
                database
                    .updateBadgeDocument(
                        badgeRequirementList,
                        widget.badgeName
                            .toLowerCase()
                            .replaceAll(' ', '-')
                            .replaceAll(',', ''))
                    .whenComplete(() => database.updateBadgeProgressField(
                        widget.badgeName
                            .toLowerCase()
                            .replaceAll(' ', '-')
                            .replaceAll(',', ''),
                        badgeRequirementList));
              },
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        );
      },
    );
  }

  Future<BadgeView> futureBadge;

  @override
  void initState() {
    final String uid = Provider.of<String>(context, listen: false);
    futureBadge = DatabaseService(uid: uid)
        .getBadgeData(widget.badgeName
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(',', ''))
        .then((value) async => BadgeView(
            badgeRequirementList: await value,
            setChangesSaved: setChangesSaved));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);

    return FutureBuilder(
        future: futureBadge,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
              onWillPop: () async {
                if (_changesSaved ?? true) {
                  return true;
                } else {
                  return await _showSaveDialog(
                      uid, snapshot.data.badgeRequirementList);
                }
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: false,

                  leading: IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.redAccent[100],
                    ),
                    onPressed: () async {
                      if (_changesSaved ?? true) {
                        return Navigator.of(context).pop();
                      } else {
                        await _showSaveDialog(
                            uid, snapshot.data.badgeRequirementList);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  elevation: 0,
                  // leading: IconButton(
                  //     icon: Icon(Icons.menu), onPressed: widget.showDrawer()),
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,

                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: widget.badgeName,
                        child: Image.asset(
                            'assets/images/badges/${widget.badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '')}.png',
                            height: 40,
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
                              color: Colors.redAccent[100],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    _changesSaved == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(right: 10),
                            child: FilterChip(
                              pressElevation: 0,
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.redAccent[100],
                              selectedColor: Colors.greenAccent,
                              selected: _changesSaved,
                              onSelected: (newValue) async {
                                if (newValue) {
                                  DatabaseService database =
                                      DatabaseService(uid: uid);
                                  database
                                      .updateBadgeDocument(
                                          snapshot.data.badgeRequirementList,
                                          widget.badgeName
                                              .toLowerCase()
                                              .replaceAll(' ', '-')
                                              .replaceAll(',', ''))
                                      .whenComplete(() =>
                                          database.updateBadgeProgressField(
                                              widget.badgeName
                                                  .toLowerCase()
                                                  .replaceAll(' ', '-')
                                                  .replaceAll(',', ''),
                                              snapshot
                                                  .data.badgeRequirementList));

                                  print('saved reqs');
                                  setState(() => _changesSaved = true);
                                }
                              },
                              label: Text(
                                _changesSaved ? 'Saved' : 'Save',
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
                    snapshot.data,
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
