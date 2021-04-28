import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softwaretorchapp/constants.dart';
import 'package:softwaretorchapp/firstscreen.dart';
import 'package:softwaretorchapp/homescreen.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
String userOpinion;
PickedFile stateImage;
var scaffoldKey = GlobalKey<ScaffoldState>();

class AddState extends StatefulWidget {
  String userDiscordTag;
  String userEmail;
  AddState({this.userDiscordTag, this.userEmail});
  @override
  _AddStateState createState() => _AddStateState();
}

class _AddStateState extends State<AddState> {
  String url;

  var flp = FlutterLocalNotificationsPlugin();
  Future<void> kurulum() async {
    var androidInitilialSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitilialSettings = IOSInitializationSettings();
    var initalSettings =
        InitializationSettings(androidInitilialSettings, iosInitilialSettings);
    await flp.initialize(initalSettings, onSelectNotification: bildirimSecilme);
  }

  Future<void> bildirimSecilme(String payload) async {
    if (payload != null) {
      print("Bildirim Secildi");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kurulum();
  }

  Future<void> bildirimGoster({String notTitle, String notBody}) async {
    var androidNotificationDetails = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.Max, priority: Priority.High);
    var iosNotificationDetails = IOSNotificationDetails();
    var notifivationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flp.show(0, notTitle, notBody, notifivationDetails);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: Stack(children: [
        SizedBox(
            height: double.infinity,
            child: Image.asset(
              "assets/images/addstatebg.jpg",
              fit: BoxFit.cover,
            )),
        Column(
          children: [
            SizedBox(height: size.height * 0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.8,
                  child: TextFormField(
                    maxLength: 200,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Expression",
                      hintStyle: TextStyle(color: ksecondary),
                    ),
                    onChanged: (opinion) {
                      userOpinion = opinion;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            SizedBox(
              height: size.height * 0.08,
              width: size.width * 0.3,
              //${stateAmount}State
              //widget.userDiscordTag.toString()
              child: GestureDetector(
                onTap: _createState,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [Color(0xFFC49E93), Color(0xFFD9D1CF)]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      "Share!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ]),
    );
  }

  /*void _pickPicture() async {
    var _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      stateImage = image;
    });
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("Users")
        .child(widget.userDiscordTag.toString())
        .child("StatePhoto");
    UploadTask uploadTask = ref.putFile(File(stateImage.path));

    url =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  }*/

  void _createState() async {
    if (!(stateImage == null && userOpinion == "")) {
      DocumentSnapshot documentSnapshot = await firestore
          .doc("Users/${widget.userEmail.toString()}/AvatarPicture/AvatarUrl")
          .get();
      var avatarUrl = documentSnapshot.data()["UserAvatarUrl"];
      //StateAmount
      DocumentSnapshot documentSnapshotStateAmount =
          await firestore.doc("StateAmount/Amount").get();
      var stateAmount =
          await documentSnapshotStateAmount.data()["TotalStateAmount"];
      stateAmount++;
      await firestore
          .collection("StateAmount")
          .doc("Amount")
          .set({"TotalStateAmount": stateAmount});
      await firestore.collection("States").doc("State${stateAmount}").set({
        "UserStateImageUrl": url,
        "UserStateOpinion": userOpinion,
        "DiscordTag": widget.userDiscordTag.toString(),
        "AvatarUrl": avatarUrl,
        "nthState": stateAmount
      }, SetOptions(merge: true));
      await firestore.collection("NavigationState").doc("NavState").set({
        "setUpNav":"true"
      });
      
      
      userOpinion = "";
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Durumunuz başarıyla paylaşıldı!"),
      ));
      
    }
  }
}
