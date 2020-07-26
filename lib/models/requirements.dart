import 'package:cloud_firestore/cloud_firestore.dart';

class RequirementList {
  List<Requirement> reqList;
  int numChildren;
  int numChildrenRequired;
  int numChildrenComplete;
  // int numComplete;

  //create reqList from json template
  RequirementList.fromTemplate(Map<String, dynamic> template,
      {int childrenRequired}) {
    List<Requirement> reqs = [];

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
        Requirement(
          id: key,
          isCheckable: !(value is List),
          description: value is List ? value[0] : value,
          subReqs: value is List
              ? RequirementList.fromTemplate(value[2],
                  childrenRequired: value[1])
              : null,
        ),
      );
    });
    this.reqList = reqs;
  }

  //convert reqList to a map for firestore (recursive)
  Map<String, dynamic> convertReqListToFirestore(RequirementList reqs) {
    Map<String, dynamic> firestoreData = {};

    reqs.reqList.forEach((req) => firestoreData.addAll({
          req.id: {
            'initials': req.initials,
            'date': req.date,
            'subReqs': req.subReqs == null
                ? null
                : convertReqListToFirestore(req.subReqs),
          }
        }));

    return firestoreData;
  }

  //create/update Firestore map from reqList
  Future<void> updateRequirementListDocument(DocumentReference doc) {
    Map<String, dynamic> firestoreData = convertReqListToFirestore(this);

    return doc.setData(firestoreData);
  }

//get reqList from firestoreData/template
  RequirementList.fromFirestore(
      DocumentSnapshot snapshot, Map<String, dynamic> template) {
    List<Requirement> reqs = [];
    //copy data from template
    template.forEach((key, value) => reqs.add(
          Requirement(
            id: key,
            isCheckable: !(value is List),
            description: value is List ? value[0] : value,
            subReqs:
                value is List ? RequirementList.fromTemplate(value[1]) : null,
          ),
        ));
    reqs.forEach((req) {
      req.date = snapshot.data[req.id]['date'];
      req.initials = snapshot.data[req.initials]['initials'];
    });

    this.reqList = reqs;
    //update firebase document for badge progress with local object
  }
}

class Requirement {
  Requirement(
      {this.id = '',
      this.isCheckable = true,
      this.isComplete = false,
      this.subReqs,
      this.initials = '',
      this.description = '',
      this.date = ''});

  String id;
  bool isCheckable;
  bool isComplete;
  String initials;
  String description;
  RequirementList subReqs;
  String date;
}
