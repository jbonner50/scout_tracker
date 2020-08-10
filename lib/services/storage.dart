import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class StorageService {
  final String uid;
  StorageService({this.uid});

  // collection reference
  final StorageReference scoutStorage = FirebaseStorage.instance.ref();

  Future getBadgeJson(String hyphenatedBadgeName) async {
    final StorageReference jsonFile =
        scoutStorage.child('badges/$hyphenatedBadgeName-v1.json');
    try {
      String downloadUrl = await jsonFile.getDownloadURL();
      final Response response = await get(downloadUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Request failed with status: ${response.statusCode}. Badge $hyphenatedBadgeName');
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveBadgeJson(String hyphenatedBadgeName) async {
    dynamic badgeData = await getBadgeJson(hyphenatedBadgeName);

    if (badgeData != null) {
      //TODO add check to see if files exist

      final directory = await getApplicationDocumentsDirectory();
      File badgeFile =
          File('${directory.path}/badges/$hyphenatedBadgeName.json');
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

  Future<void> saveAllBadgesJson(List badgeNames) async {
    // final dir = await getApplicationDocumentsDirectory();
    // dir.deleteSync(recursive: true);

    for (var badgeName in badgeNames) {
      String hyphenatedBadgeName =
          badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '');
      saveBadgeJson(hyphenatedBadgeName);
    }

    /*
    // Create a reference under which you want to list
var listRef = storageRef.child('files/uid');

// Find all the prefixes and items.
listRef.listAll().then(function(res) {
  res.prefixes.forEach(function(folderRef) {
    // All the prefixes under listRef.
    // You may call listAll() recursively on them.
  });
  res.items.forEach(function(itemRef) {
    // All the items under listRef.
  });
}).catch(function(error) {
  // Uh-oh, an error occurred!
});
*/
  }

  // void precacheImages(List badgeNames, BuildContext context) {
  //   for (var badgeName in badgeNames) {
  //     String hyphenatedBadgeName =
  //         badgeName.toLowerCase().replaceAll(' ', '-').replaceAll(',', '');
  //     precacheImage(
  //         AssetImage('assets/images/badges/$hyphenatedBadgeName.png'), context);
  //   }
  // }

  Future readBadgeJson(String hyphenatedBadgeName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File badgeFile =
          File('${directory.path}/badges/$hyphenatedBadgeName.json');
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
