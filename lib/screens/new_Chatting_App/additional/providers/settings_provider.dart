import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';

class SettingProvider {
  SharedPreferences preferences;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  SettingProvider({
    @required this.preferences,
    @required this.firebaseStorage,
    @required this.firebaseFirestore,
  });
  String getPref(String key) {
    return preferences.getString(key);
  }

  Future<bool> setPref(String key, String value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setString(key, value);
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }
}

class SettingDetails extends StatelessWidget {
  String dataHeader;
  String hintText;
  Function onChanged;
  TextEditingController textEditingController;
  FocusNode focusNode;

  SettingDetails(
      {this.focusNode,
      this.textEditingController,
      this.onChanged,
      @required this.hintText,
      @required this.dataHeader});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            dataHeader,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: lightBLueColor),
          ),
          margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(primaryColor: lightBLueColor),
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(5.0),
              ),
              controller: textEditingController,
              onChanged: onChanged,
              focusNode: focusNode,
            ),
          ),
          margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
        ),
      ],
    );
  }
}
