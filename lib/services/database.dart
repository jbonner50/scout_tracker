import 'package:cloud_firestore/cloud_firestore.dart';

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

  // collection reference
  final CollectionReference scoutCollection =
      Firestore.instance.collection('scouts');

  Future createScout(String username, int rank) async {
    return scoutCollection.document(uid).setData({
      'username': username,
      'rank': rank,
    }).then((_) => scoutCollection.document(uid)
      ..collection('badges')
      ..collection('ranks'));

    //TODO create all badge and rank progress documents inside ranks and badges collections using BATCH for firestore
  }

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
