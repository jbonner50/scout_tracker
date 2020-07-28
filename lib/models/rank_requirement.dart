// class RankRequirement extends Requirement {
//   final RankRequirementList subReqs;
//   Date date;
//   String initials;
//   RankRequirement(
//       {id = '',
//       isCheckable = true,
//       isComplete = false,
//       description = '',
//       this.subReqs,
//       this.date,
//       this.initials})
//       : super(
//             id: id,
//             isCheckable: isCheckable,
//             description: description,
//             isComplete: isComplete);
// }

// class RankRequirementList {
//   List<RankRequirement> reqList;
//   int numChildren;
//   int numChildrenRequired;
//   int numChildrenComplete;
//   // int numComplete;

//   //create/update Firestore map from reqList
//   Future<void> updateRequirementListDocument(DocumentReference doc) {
//     Map<String, dynamic> firestoreData = convertReqListToFirestore(this);

//     return doc.setData(firestoreData);
//   }

//   //create reqList from json template
//   RankRequirementList.fromJson(Map<String, dynamic> template,
//       {int childrenRequired}) {
//     List<RankRequirement> reqs = [];

//     if (template.containsKey("root")) {
//       this.numChildren = template["root"].length;
//       this.numChildrenRequired = this.numChildren;
//       this.numChildrenComplete = 0;
//       template = template["root"];
//     } else {
//       this.numChildren = template.length;
//       this.numChildrenRequired = childrenRequired;
//       this.numChildrenComplete = 0;
//     }

//     template.forEach((key, value) {
//       reqs.add(
//         RankRequirement(
//           id: key,
//           isCheckable: !(value is List),
//           description: value is List ? value[0] : value,
//           subReqs: value is List
//               ? RankRequirementList.fromJson(value[2],
//                   childrenRequired: value[1])
//               : null,
//         ),
//       );
//     });
//     this.reqList = reqs;
//   }

//   // convert reqList to a map for firestore (recursive)
//   Map<String, dynamic> convertReqListToFirestore(RankRequirementList reqs) {
//     Map<String, dynamic> firestoreData = {};

//     reqs.reqList.forEach((req) => firestoreData.addAll({
//           req.id: {
//             'isComplete': req.isComplete,
//             'initials': req.initials,
//             'date': req.date.toString(),
//             'subReqs': req.subReqs == null
//                 ? null
//                 : convertReqListToFirestore(req.subReqs),
//           }
//         }));

//     return firestoreData;
//   }

// //get reqList from firestoreData/template
//   RankRequirementList.fromFirestore(
//       DocumentSnapshot snapshot, Map<String, dynamic> template) {
//     List<RankRequirement> reqs = [];
//     //copy data from template
//     template.forEach((key, value) => reqs.add(
//           RankRequirement(
//             id: key,
//             isCheckable: !(value is List),
//             description: value is List ? value[0] : value,
//             subReqs:
//                 value is List ? RankRequirementList.fromJson(value[1]) : null,
//           ),
//         ));
//     reqs.forEach((req) {
//       req.isComplete = snapshot.data[req.id]['isComplete'];
//       req.initials = snapshot.data[req.id]['initials'];
//       req.date = Date.fromDateFormat(snapshot.data[req.id]['date']);
//     });

//     this.reqList = reqs;
//     //update firebase document for badge progress with local object
//   }
// }
