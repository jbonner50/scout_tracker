import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scout_tracker/models/badge_requirements.dart';
import 'package:scout_tracker/services/storage.dart';

// class Date {
//   Date({this.month, this.day, this.year});
//   final int month;
//   final int day;
//   final int year;

//   String format() => '$month/$day/$year';

//   factory Date.currentDate() {
//     DateTime current = DateTime.now();
//     return Date(
//       month: current.month,
//       day: current.day,
//       year: current.year,
//     );
//   }
// }

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  List<String> inprogress;
  List<String> earned;
  List<String> unearned;

  // collection reference
  final CollectionReference scoutCollection =
      Firestore.instance.collection('scouts');

  Future createScout(String username, String rank) async {
    List badgeNames = LineSplitter()
        .convert(await rootBundle.loadString('data/badge_list.txt'));
    return scoutCollection.document(uid).setData({
      'username': username,
      'rank': rank,
      'badge_progress': Map.fromIterable(badgeNames,
          key: (k) => k.toLowerCase().replaceAll(' ', '-').replaceAll(',', ''),
          value: (v) => 0),
    });

    // .then((_) => scoutCollection.document(uid)
    //   ..collection('badges')
    //   ..collection('ranks'));
  }

  Future updateBadgeProgressField(String hyphenatedBadgeName,
      BadgeRequirementList badgeRequirementList) async {
    DocumentSnapshot user = await scoutCollection.document(uid).get();
    Map progress = user.data['badge_progress'];
    progress.update(
        hyphenatedBadgeName, (_) => badgeRequirementList.requirementProgress);
    return scoutCollection.document(uid).setData({
      'badge_progress': progress,
    }, merge: true);
  }

  Stream get user => scoutCollection.document(uid).snapshots();

  Future getBadgeData(String hyphenatedBadgeName) async {
    DocumentSnapshot doc = await scoutCollection
        .document(uid)
        .collection('badges')
        .document(hyphenatedBadgeName)
        .get();
    print(doc.exists);
    Map<String, dynamic> templateData =
        await StorageService().readBadgeJson(hyphenatedBadgeName);
    return doc.exists
        ? BadgeRequirementList.fromFirestoreMain(templateData, doc.data)
        : BadgeRequirementList.fromJsonMain(templateData);
  }

  //create/update Firestore map from reqList
  Future updateRequirementListDocument(
      BadgeRequirementList badgeRequirementList, String hyphenatedBadgeName) {
    Map<String, dynamic> firestoreData =
        badgeRequirementList.convertReqListToFirestore();

    return scoutCollection
        .document(uid)
        .collection('badges')
        .document(hyphenatedBadgeName)
        .setData(firestoreData);

    // badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', ''))
  }

  // //set list of badges based on progress
  // Future<void> updateBadgeList(String hyphenatedBadgeName, BadgeRequirementList badgeRequirementList) async {
  //   DocumentReference user = scoutCollection.document(uid);
  //   if(badgeRequirementList.subReqsComplete) {
  //     //badge is complete
  //   user.setData({"badges_in_progress": [...hyphenatedBadgeName]});

  //   } else {
  //     //badge is in progress
  //   }
  // }

//   //brew list from snapshot
//   List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.documents.map((doc) {
//       return Brew(
//         name: doc.data['name'] ?? '',
//         strength: doc.data['strength'] ?? 0,
//         sugars: doc.data['sugars'] ?? '0',
//       );
//     }).toList();
//   }

// // userData from snapshot
//   UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//     return UserData(
//       uid: uid,
//       name: snapshot.data['name'],
//       sugars: snapshot.data['sugars'],
//       strength: snapshot.data['strength'],
//     );
//   }

//   // get brews stream
//   Stream<List<Brew>> get brews {
//     return brewCollection.snapshots().map(_brewListFromSnapshot);
//   }

//   //get user doc stream
//   Stream<UserData> get userData {
//     return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
//   }
// }
}
