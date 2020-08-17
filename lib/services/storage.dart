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
    final directory = await getApplicationDocumentsDirectory();
    File badgeFile = File('${directory.path}/badges/$hyphenatedBadgeName.json');
    if (!badgeFile.existsSync()) {
      //   //add new loadout to file
      //   badgeFile.writeAsString(json.encode(badgeData));
      // } else {
      //create file and add new loadout as first entry
      dynamic badgeData = await getBadgeJson(hyphenatedBadgeName);

      if (badgeData != null) {
        //TODO add check to see if files exist

        print('created');
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
  }

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

  Future getRankJson(String hyphenatedRankName) async {
    final StorageReference jsonFile =
        scoutStorage.child('ranks/$hyphenatedRankName-v1.json');
    try {
      String downloadUrl = await jsonFile.getDownloadURL();
      final Response response = await get(downloadUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Request failed with status: ${response.statusCode}. Rank $hyphenatedRankName');
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveRankJson(String hyphenatedRankName) async {
    final directory = await getApplicationDocumentsDirectory();
    File rankFile = File('${directory.path}/ranks/$hyphenatedRankName.json');
    if (!rankFile.existsSync()) {
      //   //add new loadout to file
      //   rankFile.writeAsString(json.encode(rankData));
      // } else {
      //create file and add new loadout as first entry
      dynamic rankData = await getRankJson(hyphenatedRankName);

      if (rankData != null) {
        //TODO add check to see if files exist
        print('created');
        rankFile.createSync(recursive: true);
        rankFile.writeAsStringSync(json.encode(rankData));
      }
    }
  }

  Future<void> saveAllRanksJson() async {
    // final dir = await getApplicationDocumentsDirectory();
    // dir.deleteSync(recursive: true);
    final List<String> rankNames = [
      'Scout',
      'Tenderfoot',
      'Second Class',
      'First Class',
      'Star',
      'Life',
      'Eagle',
    ];
    for (var rankName in rankNames) {
      String hyphenatedRankName = rankName.toLowerCase().replaceAll(' ', '-');
      await saveRankJson(hyphenatedRankName);
    }
  }

  Future readRankJson(String hyphenatedRankName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File rankFile = File('${directory.path}/ranks/$hyphenatedRankName.json');
      String contents = await rankFile.readAsString();
      dynamic data = json.decode(contents);
      return data;
    } catch (e) {
      // If encountering an error, return 0.
      print('error');
      return 0;
    }
  }
}
