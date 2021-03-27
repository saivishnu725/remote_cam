import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File _image;
  final picker = ImagePicker();
  chooseImage(ImageSource imageSource) async {
    final pickedImage = await picker.getImage(source: imageSource);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Camera",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: _image != null
              ? Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    // color: Colors.green,
                    image: DecorationImage(
                      image: FileImage(_image),
                    ),
                  ),
                )
              : Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 200.0,
            // height: 200.0,
          ),
          FloatingActionButton(
            onPressed: () {
              chooseImage(ImageSource.gallery);
            },
            child: Text("Gal"),
          ),
          SizedBox(
            width: 20.0,
            // height: 200.0,
          ),
          FloatingActionButton(
            onPressed: () {
              chooseImage(ImageSource.camera);
            },
            child: Text("Cam"),
          ),
        ],
      ),
    );
  }
}
