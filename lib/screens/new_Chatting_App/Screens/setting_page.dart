import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/settings_provider.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/user_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {
  static String id = 'settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        backgroundColor: lightBLueColor,
        title: Text(
          'Account Settings',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingPage(),
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences prefrences;
  String id = "";
  String nickname = "";
  String aboutMe = "";
  String photoUrl = "";
  String phoneNumber = "";
  File imageFileAvatar;
  bool isLoading = false;
  SettingProvider settingProvider;

  String dialCodeDigits = "+00";
  final TextEditingController _controller = TextEditingController();
  TextEditingController nicknameTextEditingController = TextEditingController();
  TextEditingController aboutMeTextEditingController = TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingProvider = context.read<SettingProvider>();
    readDataFromLocal();
  }

  void readDataFromLocal() async {
    prefrences = await SharedPreferences.getInstance();
    print('${prefrences.getString(FirebaseConstants.photoUrl)} hello world');
    setState(() {
      id = prefrences.getString(FirebaseConstants.id);
      nickname = prefrences.getString(FirebaseConstants.nickname);
      aboutMe = prefrences.getString(FirebaseConstants.aboutMe);
      photoUrl = prefrences.getString(FirebaseConstants.photoUrl);
      phoneNumber = prefrences.getString(FirebaseConstants.phoneNumber);
    });
    print(photoUrl);
    nicknameTextEditingController = TextEditingController(text: nickname);
    aboutMeTextEditingController = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker
        .getImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        imageFileAvatar = image;
        isLoading = false;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask =
        settingProvider.uploadFile(imageFileAvatar, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();

      UserChat updateInfo = UserChat(
          id: id,
          aboutMe: aboutMe,
          photoUrl: photoUrl,
          nickname: nickname,
          phoneNumber: phoneNumber);
      settingProvider
          .updateDataFirestore(
              FirebaseConstants.pathUserCollection, id, updateInfo.toJson())
          .then((data) async {
        await settingProvider.setPref(FirebaseConstants.photoUrl, photoUrl);
        print("upload success");
        setState(() {
          isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void handleUpdateData() {
    nicknameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();

    setState(() {
      isLoading = true;
      if (dialCodeDigits != "+00" && _controller.text != "") {
        phoneNumber = dialCodeDigits + _controller.text.toString();
      }
    });
    UserChat updateInfo = UserChat(
        id: id,
        aboutMe: aboutMe,
        photoUrl: photoUrl,
        nickname: nickname,
        phoneNumber: phoneNumber);
    settingProvider
        .updateDataFirestore(
            FirebaseConstants.pathUserCollection, id, updateInfo.toJson())
        .then((data) async {
      await settingProvider.setPref(FirebaseConstants.nickname, nickname);
      await settingProvider.setPref(FirebaseConstants.aboutMe, aboutMe);
      await settingProvider.setPref(FirebaseConstants.photoUrl, photoUrl);
      await settingProvider.setPref(FirebaseConstants.phoneNumber, phoneNumber);
      print(photoUrl);

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Update Success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoButton(
                  onPressed: getImage,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: imageFileAvatar == null
                        ? photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                  errorBuilder: (context, object, stackTrace) {
                                    print(
                                        'error occur in getting the photoUrl');
                                    return Icon(
                                      Icons.account_circle,
                                      size: 120,
                                      color: Colors.grey,
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    print('loading Builder implemented');
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.grey,
                                          value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.image,
                                size: 120,
                                color: Colors.grey,
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.file(
                              imageFileAvatar,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Column(
                  children: [
                    SettingDetails(
                        focusNode: nicknameFocusNode,
                        textEditingController: nicknameTextEditingController,
                        onChanged: (value) {
                          nickname = value;
                        },
                        hintText: 'Write your name...',
                        dataHeader: "ProfileName"),
                    SettingDetails(
                        focusNode: aboutMeFocusNode,
                        textEditingController: aboutMeTextEditingController,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        hintText:
                            'Hey there I am using Vaibhav\'s Chatting app',
                        dataHeader: "About You"),
                    Center(
                      child: Container(
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: lightBLueColor),
                        ),
                        margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: lightBLueColor),
                        child: TextField(
                          style: TextStyle(color: Colors.grey),
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: phoneNumber,
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                      child: SizedBox(
                        width: 400,
                        height: 60,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              dialCodeDigits = country.dialCode;
                            });
                          },
                          initialSelection: "+91",
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          favorite: ["+91", "IND"],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightBLueColor),
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                dialCodeDigits,
                                style: TextStyle(color: Colors.black38),
                              ),
                            )),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: _controller,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                  child: RawMaterialButton(
                    onPressed: handleUpdateData,
                    child: Text(
                      'Update Now',
                      style: TextStyle(fontSize: 16, color: whiteColor),
                    ),
                    fillColor: lightBLueColor,
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  ),
                  margin: EdgeInsets.only(top: 51, bottom: 1),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
//TODO: this is the avatar which i have implemented from old video use it as a refrence
// Container(
// child: Center(
// child: Stack(
// children: <Widget>[
// (imageFileAvatar == null)
// ? photoUrl != null
// ? Material(
// child: CachedNetworkImage(
// placeholder: (context, url) => Container(
// child: CircularProgressIndicator(
// strokeWidth: 2,
// valueColor:
// AlwaysStoppedAnimation<Color>(
// lightBLueColor),
// ),
// width: 200,
// height: 200,
// padding: EdgeInsets.all(20),
// ),
// imageUrl: photoUrl,
// width: 200,
// height: 200,
// fit: BoxFit.cover,
// ),
// borderRadius:
// BorderRadius.all(Radius.circular(125)),
// clipBehavior: Clip.hardEdge,
// )
// : Icon(
// Icons.account_circle,
// size: 60,
// color: Colors.grey,
// )
// : Material(
// child: Image.file(
// imageFileAvatar,
// width: 200,
// height: 200,
// fit: BoxFit.cover,
// ),
// borderRadius:
// BorderRadius.all(Radius.circular(125)),
// clipBehavior: Clip.hardEdge,
// ),
// IconButton(
// onPressed: getImage,
// icon: Icon(
// Icons.camera_alt,
// size: 100,
// color: Colors.white54.withOpacity(0.2),
// ))
// ],
// ),
// ),
// ),
