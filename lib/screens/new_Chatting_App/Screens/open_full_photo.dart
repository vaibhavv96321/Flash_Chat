import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoView extends StatelessWidget {
  String url;
  FullPhotoView({@required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(
          color: lightBLueColor,
        ),
        title: Text(
          'Image Full Size',
          style: TextStyle(color: lightBLueColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
