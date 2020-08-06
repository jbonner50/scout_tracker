import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:scout_tracker/models/badge_requirements.dart';

class StorageService {
  final String uid;
  StorageService({this.uid});

  // collection reference
  final StorageReference scoutStorage = FirebaseStorage.instance.ref();

  Future getBadgeJson() async {
    final StorageReference jsonFile =
        scoutStorage.child('badges/golf/golf_v1.json');

    String downloadUrl = await jsonFile.getDownloadURL();
    final Response response = await get(downloadUrl);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<void> saveBadgeJson() async {
    dynamic badgeData = await getBadgeJson();

    if (badgeData != null) {
      final dir = await getApplicationDocumentsDirectory();
      dir.deleteSync(recursive: true);
      final directory = await getApplicationDocumentsDirectory();
      File badgeFile = File('${directory.path}/badges/golf/golf_v1.json');
      if (badgeFile.existsSync()) {
        //add new loadout to file
        badgeFile.writeAsString(json.encode(badgeData));
      } else {
        //create file and add new loadout as first entry
        badgeFile.createSync(recursive: true);
        badgeFile.writeAsStringSync(json.encode(badgeData));
      }
    }
  }

  Future readBadgeJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File badgeFile = File('${directory.path}/badges/golf/golf_v1.json');
      String contents = await badgeFile.readAsString();
      dynamic data = json.decode(contents);
      return data;
    } catch (e) {
      // If encountering an error, return 0.
      print('error');
      return 0;
    }
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
