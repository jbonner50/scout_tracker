import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Date {
  int month;
  int day;
  int year;

  Date({this.month, this.day, this.year});

//from string XX/XX/XXXX
  Date.fromDateFormat(String formatted) {
    List<String> splitDate = formatted.split('/');
    this.month = int.parse(splitDate[0]);
    this.day = int.parse(splitDate[1]);
    this.year = int.parse(splitDate[2]);
  }

//to string XX/XX/XXXX
  @override
  String toString() {
    return '${this.month}/${this.day}/${this.year}';
  }
}

class BadgeRequirementList {
  List<BadgeRequirement> reqList;
  int numChildren;
  int numChildrenRequired;
  int numChildrenComplete;
  bool subReqsComplete = false;
  BadgeRequirement parent;

  void updateNumChildrenComplete() {
    int complete = 0;
    this.reqList.forEach((req) {
      print(req.isComplete);
      if (req.isComplete) complete++;
    });
    this.numChildrenComplete = complete;

    this.subReqsComplete =
        (this.numChildrenComplete == this.numChildrenRequired);
    parent?.setIsComplete(this.subReqsComplete);
  }

  //create/update Firestore map from reqList
  Future<void> updateRequirementListDocument(DocumentReference doc) {
    Map<String, dynamic> firestoreData = convertReqListToFirestore(this);

    return doc.setData(firestoreData);
  }

  //create reqList from json template
  BadgeRequirementList.fromJson(Map<String, dynamic> template,
      {int childrenRequired, BadgeRequirement parent}) {
    List<BadgeRequirement> reqs = [];

    if (template.containsKey("root")) {
      this.numChildren = template["root"].length;
      this.numChildrenRequired = this.numChildren;
      this.numChildrenComplete = 0;
      template = template["root"];
    } else {
      this.numChildren = template.length;
      this.numChildrenRequired = childrenRequired;
      this.numChildrenComplete = 0;
    }

    template.forEach((key, value) {
      reqs.add(
        BadgeRequirement.fromJson(key: key, value: value, parent: this),
      );
    });
    this.parent = parent;
    this.reqList = reqs;
    this.numChildrenRequired = reqList.length;
  }

  // convert reqList to a map for firestore (recursive)
  Map<String, dynamic> convertReqListToFirestore(BadgeRequirementList reqs) {
    Map<String, dynamic> firestoreData = {};

    reqs.reqList.forEach((req) => firestoreData.addAll({
          req.id: {
            'isComplete': req.isComplete,
            'subReqs': req.subReqs == null
                ? null
                : convertReqListToFirestore(req.subReqs),
          }
        }));

    return firestoreData;
  }

//get reqList from firestoreData/template
  BadgeRequirementList.fromFirestore(
      DocumentSnapshot snapshot, Map<String, dynamic> template) {
    List<BadgeRequirement> reqs = [];
    //copy data from template
    template.forEach((key, value) => reqs
        .add(BadgeRequirement.fromJson(key: key, value: value, parent: this)));
    reqs.forEach((req) {
      req.isComplete = snapshot.data[req.id]['isComplete'];
    });

    this.reqList = reqs;
    //update firebase document for badge progress with local object
  }
}

class BadgeRequirement extends ChangeNotifier {
  String id;
  bool isCheckable;
  bool isComplete;
  String description;
  BadgeRequirementList subReqs;
  BadgeRequirementList parent;

  void setIsComplete([bool newValue]) {
    if (newValue != null)
      this.isComplete = !this.isComplete;
    else
      this.isComplete = newValue;
    notifyListeners();
  }

  // BadgeRequirement({
  //   this.id = '',
  //   this.isCheckable = true,
  //   this.isComplete = false,
  //   this.description = '',
  //   this.subReqs,
  //   this.parent,
  // });

  BadgeRequirement.fromJson(
      {String key, dynamic value, BadgeRequirementList parent}) {
    this.id = key;
    this.isCheckable = !(value is List);
    this.isComplete = false;
    this.description = value is List ? value[0] : value;
    this.subReqs = value is List
        ? BadgeRequirementList.fromJson(value[2],
            childrenRequired: value[1], parent: this)
        : null;
    this.parent = parent;
  }
}
