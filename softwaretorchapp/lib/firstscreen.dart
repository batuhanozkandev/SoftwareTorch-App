import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softwaretorchapp/constants.dart';
import 'package:softwaretorchapp/homescreen.dart';
import 'package:softwaretorchapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
var scaffoldKey = GlobalKey<ScaffoldState>();
String userEmail;
String userPassword;
String userTag;
int stateCounter = 0;
int totalStateAmount = 0;
bool girisYapildi=false;
String hintText;

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (girisYapildi) {
      hintText = userEmail;
    } else {
      hintText = "Your Mail";
    }
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    Size size = MediaQuery.of(context).size;
    var _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ksecondary,
          title: Text(
            "Software Torch",
            style: TextStyle(color: kprimary, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: kprimary,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text("Log In"),
                icon: Icon(Icons.login),
              ),
              Tab(
                child: Text("Create Account"),
                icon: Icon(Icons.add_box),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [Colors.blue.shade300, Colors.blue.shade700]),
              ),
              child: Stack(children: [
                Positioned(
                    top: size.height * 0.25,
                    left: size.width * 0.0001,
                    child: Image.asset(
                      "assets/images/softwaretorchlogo.png",
                      scale: 0.6,
                    )),
                Positioned(
                  top: size.height * 0.15,
                  left: size.width * 0.1,
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            hintText: hintText,
                            hintStyle: TextStyle(color: ksecondary),
                            suffixIcon: Icon(
                              Icons.email,
                              color: ksecondary,
                            )),
                        onChanged: (s) {
                          

                          userEmail = s;
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailTypeControl,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.25,
                  left: size.width * 0.1,
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            hintText: "Your Password",
                            hintStyle: TextStyle(color: ksecondary),
                            suffixIcon: Icon(
                              Icons.vpn_key,
                              color: ksecondary,
                            )),
                        onChanged: (s) {
                          userPassword = s;
                        },
                        validator: _passwordTypeControl,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.45,
                  left: size.width * 0.2,
                  child: GestureDetector(
                    onTap: _logInMethod,
                    child: Container(
                      width: size.width * 0.6,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo,
                              offset: Offset(1.0, 1.0),
                              spreadRadius: 10,
                              blurRadius: 20,
                            )
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              colors: [
                                Colors.cyan.shade900,
                                Colors.cyanAccent
                              ]),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Text("LogIn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kprimary)),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Stack(children: [
              Positioned(
                  top: size.height * 0.25,
                  left: size.width * 0.0001,
                  child: Image.asset(
                    "assets/images/softwaretorchlogo.png",
                    scale: 0.6,
                  )),
              Positioned(
                top: size.height * 0.45,
                left: size.width * 0.15,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipOval(
                      child: selectedAvatar == null
                          ? Image.asset("assets/images/noi.png")
                          : Image.file(File(selectedAvatar.path))),
                ),
              ),
              Positioned(
                top: size.height * 0.45,
                left: size.width * 0.5,
                child: IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    size: 50.0,
                  ),
                  onPressed: _selectAvatarFromGallery,
                ),
              ),
              Positioned(
                top: size.height * 0.15,
                left: size.width * 0.1,
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          hintText: "Your Email",
                          hintStyle: TextStyle(color: ksecondary),
                          suffixIcon: Icon(
                            Icons.email,
                            color: ksecondary,
                          )),
                      onChanged: (s) {
                        userEmail = s;
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailTypeControl,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.25,
                left: size.width * 0.1,
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          hintText: "Your Password",
                          hintStyle: TextStyle(color: ksecondary),
                          suffixIcon: Icon(
                            Icons.vpn_key,
                            color: ksecondary,
                          )),
                      onChanged: (s) {
                        userPassword = s;
                      },
                      validator: _passwordTypeControl,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.35,
                left: size.width * 0.1,
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          hintText: "Your Discord Tag (#Ozkan)",
                          hintStyle: TextStyle(color: ksecondary),
                          suffixIcon: Icon(
                            Icons.tag,
                            color: ksecondary,
                          )),
                      onChanged: (s) {
                        userTag = s;
                      },
                      validator: _tagTypeControl,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.6,
                left: size.width * 0.2,
                child: GestureDetector(
                  onTap: _createMethod,
                  child: Container(
                    width: size.width * 0.6,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo,
                            offset: Offset(1.0, 1.0),
                            spreadRadius: 10,
                            blurRadius: 20,
                          )
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [Colors.cyan.shade900, Colors.cyanAccent]),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text("Create Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kprimary)),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ));
  }

  String _emailTypeControl(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? "Unable Email" : null;
  }

  String _passwordTypeControl(String value) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid password';
      else
        return null;
    }
  }

  String _tagTypeControl(String value) {
    Pattern pattern = '^(#(.+?))';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter tag';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid tag';
      else
        return null;
    }
  }

  void _logInMethod() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);

      DocumentSnapshot documentSnapshot =
          await firestore.doc("Users/$userEmail").get();
      var transferTag = documentSnapshot.data()["UserDiscordTag"].toString();
      DocumentSnapshot documentSnapshotEmail =
          await firestore.doc("Users/$userEmail").get();
      var transferEmail = documentSnapshotEmail.data()["UserEmail"].toString();
      DocumentSnapshot documentSnapshotAvatar =
          await firestore.doc("Users/$userEmail/AvatarPicture/AvatarUrl").get();
      var selectedAvatarUrl =
          documentSnapshotAvatar.data()["UserAvatarUrl"].toString();

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(
          discordTag: transferTag,
          userEmail: transferEmail,
          selectedAvatarUrl: selectedAvatarUrl,
        );
      }));
      userPassword = "";
      girisYapildi=true;
    } catch (e) {
      debugPrint("GİRİŞTE HATA VAR");
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _createMethod() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      firestore.collection("Users").doc(userEmail).set({
        "UserDiscordTag": userTag,
        "UserEmail": userEmail,
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Kayıt başarılı"),));

      await firestore
          .collection("Users")
          .doc(userEmail)
          .collection("AvatarPicture")
          .doc("AvatarUrl")
          .set({"UserAvatarUrl": avatarUrl.toString()});
      /*firestore
          .collection("States")
          .doc("Counter")
          .set({"UserStateCounter": stateCounter});*/

    } catch (e) {
      debugPrint("Hesap oluştururken hata oldu" + e.toString());
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _selectAvatarFromGallery() async {
    var _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      selectedAvatar = image;
    });
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("Users")
        .child(userTag)
        .child("Avatar");
    UploadTask uploadTask = ref.putFile(File(selectedAvatar.path));

    avatarUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  }
}
