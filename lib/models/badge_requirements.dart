import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BadgeRequirementList {
  List<BadgeRequirement> reqList;
  String note;
  int numChildren = 0;
  int numChildrenRequired = 0;
  int numChildrenComplete = 0;
  bool subReqsComplete = false;
  BadgeRequirement parent;

  void updateNumSubReqsComplete() {
    int complete = 0;
    this.reqList.forEach((req) {
      if (req.isComplete) complete++;
    });
    this.numChildrenComplete = complete;

    this.subReqsComplete =
        (this.numChildrenComplete == this.numChildrenRequired);
    parent?.setIsComplete(this.subReqsComplete);
  }

  // convert reqList to a map for firestore (recursive)
  Map<String, dynamic> convertReqListToFirestore() {
    Map<String, dynamic> firestoreData = {};

    this.reqList.forEach((req) => firestoreData.addAll({
          req.id: {
            'is_complete': req.isComplete,
            'sub_reqs': req.subReqs?.convertReqListToFirestore(),
          }
        }));

    return firestoreData;
  }

  //create reqList from json template
  BadgeRequirementList.fromJsonMain(Map<String, dynamic> templateMap) {
    this.numChildren = templateMap["root"].length;
    this.numChildrenRequired = templateMap["root"].length;
    this.numChildrenComplete = 0;
    this.note = templateMap.containsKey("note") ? templateMap["note"] : null;

    this.reqList = templateMap["root"]
        .map<BadgeRequirement>(
            (req) => BadgeRequirement.fromJson(req: req, parent: this))
        .toList();
  }

  BadgeRequirementList.fromJsonSub(List templateList,
      {int childrenRequired, BadgeRequirement parent}) {
    this.numChildren = templateList.length;
    this.numChildrenRequired = childrenRequired;
    this.numChildrenComplete = 0;

    this.reqList = templateList
        .map<BadgeRequirement>(
            (req) => BadgeRequirement.fromJson(req: req, parent: this))
        .toList();

    this.parent = parent;
  }

  BadgeRequirementList.fromFirestoreMain(
      Map<String, dynamic> templateMap, Map<String, dynamic> firestoreData) {
    this.numChildren = templateMap["root"].length;
    this.numChildrenRequired = templateMap["root"].length;
    this.numChildrenComplete = 0;
    this.note = templateMap.containsKey("note") ? templateMap["note"] : null;

    firestoreData.forEach((key, value) {
      if (value['is_complete']) this.numChildrenComplete++;
    });

    this.reqList = templateMap["root"]
        .map<BadgeRequirement>(
          (req) => BadgeRequirement.fromFirestore(
              req: req, firestoreData: firestoreData[req["req"]], parent: this),
        )
        .toList();
    this.parent = parent;
  }

  BadgeRequirementList.fromFirestoreSub(List templateReqs,
      {int childrenRequired,
      BadgeRequirement parent,
      Map<String, dynamic> firestoreData}) {
    this.numChildren = templateReqs.length;
    this.numChildrenRequired = childrenRequired;

    firestoreData.forEach((key, value) {
      if (value['is_complete']) this.numChildrenComplete++;
    });

    this.reqList = templateReqs
        .map<BadgeRequirement>((req) => BadgeRequirement.fromFirestore(
            req: req, firestoreData: firestoreData[req["req"]], parent: this))
        .toList();
    this.parent = parent;
  }
//get reqList from firestoreData/template
}

class BadgeRequirement extends ChangeNotifier {
  String id;
  bool isCheckable;
  bool isComplete;
  String description;
  BadgeRequirementList subReqs;
  BadgeRequirementList parent;

  void setIsComplete([bool newValue]) {
    if (newValue == null)
      this.isComplete = !this.isComplete;
    else
      this.isComplete = newValue;
    this.parent.updateNumSubReqsComplete();
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

  BadgeRequirement.fromJson({Map req, BadgeRequirementList parent}) {
    this.id = req["req"];
    this.isCheckable = req["sub_reqs"].length == 0;
    this.isComplete = false;
    this.description = req["text"];
    this.subReqs = req["sub_reqs"].length == 0
        ? null
        : BadgeRequirementList.fromJsonSub(req["sub_reqs"],
            childrenRequired: req["num_reqd"], parent: this);
    this.parent = parent;
  }

  BadgeRequirement.fromFirestore(
      {Map req,
      Map<String, dynamic> firestoreData,
      BadgeRequirementList parent}) {
    this.id = req["req"];
    this.isCheckable = req["sub_reqs"].length == 0;
    this.isComplete = firestoreData["is_complete"];
    this.description = req["text"];
    this.subReqs = req["sub_reqs"].length == 0
        ? null
        : BadgeRequirementList.fromFirestoreSub(req["sub_reqs"],
            childrenRequired: req["num_reqd"],
            firestoreData: firestoreData["sub_reqs"],
            parent: this);
    this.parent = parent;
  }
}
