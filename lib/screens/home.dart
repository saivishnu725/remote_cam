import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

// void main() => runApp(MaterialApp(home: HomeScreen()));  //Uncomment this line to make this file standalone.. :)

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File _image;
  final picker = ImagePickerPlugin();
  bool _initialised = false;
  bool _error = false;
  String fileName;
  chooseImage(ImageSource imageSource) async {
    final pickedImage = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future getName(BuildContext context) async {
    fileName = basename(DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now()));
    fileName.replaceAll(RegExp(r' +'), '-');
    debugPrint(fileName);
  }

  void initialiseFirebase() async {
    try {
      if (kIsWeb) {
        await FirebaseCoreWeb().initializeApp();
      } else {
        await Firebase.initializeApp();
      }
      setState(() {
        _initialised = true;
      });
    } catch (e) {
      setState(() {
        debugPrint(e);
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initialiseFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        body: Center(
          child: Text(
            "Got a error!!",
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 35,
            ),
          ),
        ),
      );
    }
    if (!_initialised) {
      debugPrint("$_initialised");
      // return Scaffold(
      //   appBar: AppBar(
      //     title: Text("Loading please wait."),
      //   ),
      //   body: CircularProgressIndicator(),
      // );
    }
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
                  child: Text("${_image.path} \n $fileName"),
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
              getName(context);
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
              getName(context);
            },
            child: Text("Cam"),
          ),
        ],
      ),
    );
  }
}
