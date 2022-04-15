import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../Common/additional/constants.dart';

class HomeProvider {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  HomeProvider({
    @required this.firebaseFirestore,
  });

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Object getStreamFirestore(
      String pathCollection, int limit, String textSearch) {
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .where(FirebaseConstants.nickname, isEqualTo: textSearch);
    } else {
      return firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .snapshots();
    }
  }
}
