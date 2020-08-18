import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Date {
  int month;
  int day;
  int year;

  Date.fromFormat(String formatted) {
    List split = formatted.split("/");
    this.month = int.parse(split[0]);
    this.day = int.parse(split[1]);
    this.year = int.parse(split[2]);
  }

  Date.fromDateTime(DateTime datetime) {
    this.month = datetime.month;
    this.day = datetime.day;
    this.year = int.parse(datetime.year.toString().substring(2));
  }
  @override
  toString() => '${this.month}/${this.day}/${this.year}';
}

class RankRequirementList {
  List<RankRequirement> reqList;
  String note;
  int numChildren = 0;
  int numChildrenRequired = 0;
  int numChildrenCompleted = 0;
  bool subReqsComplete = false;
  RankRequirement parent;

  void updateNumSubReqsComplete() {
    int complete = 0;
    this.reqList.forEach((req) {
      if (req.isComplete) complete++;
    });
    this.numChildrenCompleted = complete;

    this.subReqsComplete =
        (this.numChildrenCompleted >= this.numChildrenRequired);
    parent?.setIsComplete(this.subReqsComplete);
  }

  double getRequirementProgress() {
    if (this.subReqsComplete) {
      return 1;
    } else {
      return checkInProgress(this) ? 0.5 : 0;
    }
  }

  bool checkInProgress(RankRequirementList badgeReqList) {
    bool inprogress = false;
    for (var req in badgeReqList.reqList) {
      if (req.isComplete) {
        inprogress = true;
        break;
      } else if (req.subReqs != null) {
        inprogress = checkInProgress(req.subReqs);
      }
    }
    return inprogress;
  }

// convert reqList to a map for firestore (recursive)
  Map<String, dynamic> convertReqListToFirestore() {
    Map<String, dynamic> firestoreData = {};

    this.reqList.forEach((req) => firestoreData.addAll({
          req.id: {
            'is_complete': req.isComplete,
            'initials': req.initials,
            'date': req.date?.toString(),
            'sub_reqs': req.subReqs?.convertReqListToFirestore(),
          }
        }));

    return firestoreData;
  }

  //create reqList from json template
  RankRequirementList.fromJsonMain(Map<String, dynamic> templateMap) {
    this.numChildren = templateMap["root"].length;
    this.numChildrenRequired = templateMap["root"].length;
    this.numChildrenCompleted = 0;
    this.note = templateMap.containsKey("note") ? templateMap["note"] : null;

    this.reqList = templateMap["root"]
        .map<RankRequirement>(
            (req) => RankRequirement.fromJson(req: req, parent: this))
        .toList();
  }

  RankRequirementList.fromJsonSub(List templateList,
      {int childrenRequired, RankRequirement parent}) {
    this.numChildren = templateList.length;
    this.numChildrenRequired = childrenRequired;
    this.numChildrenCompleted = 0;

    this.reqList = templateList
        .map<RankRequirement>(
            (req) => RankRequirement.fromJson(req: req, parent: this))
        .toList();

    this.parent = parent;
  }

  RankRequirementList.fromFirestoreMain(
      Map<String, dynamic> templateMap, Map<String, dynamic> firestoreData) {
    this.numChildren = templateMap["root"].length;
    this.numChildrenRequired = templateMap["root"].length;
    this.numChildrenCompleted = 0;
    this.note = templateMap.containsKey("note") ? templateMap["note"] : null;

    firestoreData.forEach((key, value) {
      if (value['is_complete']) this.numChildrenCompleted++;
    });

    this.reqList = templateMap["root"]
        .map<RankRequirement>(
          (req) => RankRequirement.fromFirestore(
              req: req, firestoreData: firestoreData[req["req"]], parent: this),
        )
        .toList();
    this.parent = parent;
  }

  RankRequirementList.fromFirestoreSub(List templateReqs,
      {int childrenRequired,
      RankRequirement parent,
      Map<String, dynamic> firestoreData}) {
    this.numChildren = templateReqs.length;
    this.numChildrenRequired = childrenRequired;

    firestoreData.forEach((key, value) {
      if (value['is_complete']) this.numChildrenCompleted++;
    });

    this.reqList = templateReqs
        .map<RankRequirement>((req) => RankRequirement.fromFirestore(
            req: req, firestoreData: firestoreData[req["req"]], parent: this))
        .toList();
    this.parent = parent;
  }
//get reqList from firestoreData/template
}

class RankRequirement extends ChangeNotifier {
  String id;
  bool isCheckable;
  bool isComplete;
  bool textbox;
  String description;
  String text;
  String initials;
  Date date;
  RankRequirementList subReqs;
  RankRequirementList parent;

  void setIsComplete(bool newValue) {
    if (newValue == null)
      this.isComplete = !this.isComplete;
    else
      this.isComplete = newValue;
    this.parent.updateNumSubReqsComplete();
    notifyListeners();
  }

  void setInitials(String initials) {
    this.initials = initials;
    notifyListeners();
  }

  void setText(String text) {
    this.text = text;
    notifyListeners();
  }

  void setDate(DateTime datetime) {
    this.date = datetime == null ? null : Date.fromDateTime(datetime);
    notifyListeners();
  }

  // RankRequirement({
  //   this.id = '',
  //   this.isCheckable = true,
  //   this.isComplete = false,
  //   this.description = '',
  //   this.subReqs,
  //   this.parent,
  // });

  RankRequirement.fromJson({Map req, RankRequirementList parent}) {
    this.id = req["req"];
    this.isCheckable = req["sub_reqs"].length == 0;
    this.isComplete = false;
    this.textbox = req.containsKey("textbox");

    this.text = '';
    this.description = req["text"];
    this.subReqs = req["sub_reqs"].length == 0
        ? null
        : RankRequirementList.fromJsonSub(req["sub_reqs"],
            childrenRequired: req["num_reqd"], parent: this);
    this.parent = parent;
  }

  RankRequirement.fromFirestore(
      {Map req,
      Map<String, dynamic> firestoreData,
      RankRequirementList parent}) {
    this.id = req["req"];
    this.isCheckable = req["sub_reqs"].length == 0;
    this.isComplete = firestoreData["is_complete"];
    this.textbox = req.containsKey("textbox");
    this.text = firestoreData["text"];
    this.initials = firestoreData["initials"];
    this.date = firestoreData["date"] == null
        ? null
        : Date.fromFormat(firestoreData["date"]);
    this.description = req["text"];
    this.subReqs = req["sub_reqs"].length == 0
        ? null
        : RankRequirementList.fromFirestoreSub(req["sub_reqs"],
            childrenRequired: req["num_reqd"],
            firestoreData: firestoreData["sub_reqs"],
            parent: this);
    this.parent = parent;
  }
}
