import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:softwaretorchapp/addstate.dart';
import 'package:softwaretorchapp/constants.dart';

import 'package:softwaretorchapp/searchpage.dart';
import 'package:softwaretorchapp/socialpage.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
List<Widget> pages;
SocialPage socialPage;
SearchPage searchPage;
AddState addStatePage;
int selectedItem = 1;
var avatarUrl;

PickedFile selectedAvatar;

class HomeScreen extends StatefulWidget {
  String discordTag;
  String userEmail;
  String selectedAvatarUrl;
  HomeScreen({this.discordTag, this.userEmail, this.selectedAvatarUrl});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socialPage = SocialPage(
      userEmail: widget.userEmail,
    );
    addStatePage = AddState(
      userDiscordTag: widget.discordTag.toString(),
      userEmail: widget.userEmail.toString(),
    );
    searchPage = SearchPage();
    pages = [searchPage, socialPage, addStatePage];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: widget.selectedAvatarUrl == null
                  ? Icon(Icons.no_photography)
                  : ClipOval(
                      child: Image.network(
                      widget.selectedAvatarUrl,
                      fit: BoxFit.cover,
                      width: 70.0,
                      height: 70.0,
                    )),
              accountName: Text(widget.discordTag.toString()),
              accountEmail: Text(widget.userEmail.toString())),
        ],
      )),
      body: selectedItem <= pages.length - 1 ? pages[selectedItem] : pages[1],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ClipOval(
                child: Image.network(
              widget.selectedAvatarUrl,
              fit: BoxFit.cover,
              width: 30.0,
              height: 30.0,
            )),
            label: "Account",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Add State",
              backgroundColor: Colors.black),
        ],
        currentIndex: selectedItem,
        onTap: (index) {
          setState(() {
            selectedItem = index;
          });
        },
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
