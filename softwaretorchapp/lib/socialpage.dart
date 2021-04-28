import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:softwaretorchapp/addstate.dart';
import 'package:softwaretorchapp/constants.dart';
import 'package:softwaretorchapp/main.dart';

List userDiscordTagList;
List userOpinionList;
//List userImageList;
List userAvatarUrlList;

class SocialPage extends StatefulWidget {
  String userEmail;
  SocialPage({this.userEmail});
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
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
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    kurulum();

    firestore
        .collection("States")
        .orderBy("nthState", descending: true)
        .get()
        .then((querySnapshot) => {
              userOpinionList = <String>[],
              //userImageList = <String>[],
              userDiscordTagList = <String>[],
              userAvatarUrlList = <String>[],
              for (var doc in querySnapshot.docs)
                {
                  userOpinionList.add(doc.data()["UserStateOpinion"]),
                  //userImageList.add(doc.data()["UserStateImageUrl"]),
                  userDiscordTagList.add(doc.data()["DiscordTag"]),
                  userAvatarUrlList.add(doc.data()["AvatarUrl"]),
                },
              setState(() async {
                DocumentSnapshot documentSnapshot =
                    await firestore.doc("NavigationState/NavState").get();
                if ((documentSnapshot.data()["setUpNav"]) == "true") {
                  bildirimGoster(
                      notTitle:
                          userDiscordTagList[userDiscordTagList.length - 1],
                      notBody: userOpinionList[userOpinionList.length - 1]);
                  await firestore
                      .collection("NavigationState")
                      .doc("NavState")
                      .set({"setUpNav": "false"});
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    debugPrint(size.width.toString());
    debugPrint(size.height.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          userOpinionList == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: userOpinionList.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, top: 30, bottom: 15),
                              //*****************************SOCIALCARD*********************************
                              child: Container(
                                height: size.height * 0.3,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.09,
                                    ),
                                    //**********OPINION***************** */
                                    /*userOpinionList == null
                                        ? CircularProgressIndicator()
                                        : Padding(
                                          padding: const EdgeInsets.only(left:15.0,top: 15),
                                          child: Text(
                                              userOpinionList[index].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                        ),
                                    */

                                    /* Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        userImageList == null
                                            ? CircularProgressIndicator()
                                            :
                                            //ımage***********
                                            Expanded(
                                                child: userAvatarUrlList == null
                                                    ? CircularProgressIndicator()
                                                    : Container(
                                                        width: 400,
                                                        height: 200,
                                                        child: Image.network(
                                                          userImageList[index]
                                                              .toString(),
                                                          scale: 1.0,
                                                        ),
                                                      ),
                                              )
                                      ],
                                    ),*/
                                    //likedbar***********************
                                    /*Container(
                                      width: double.infinity,
                                      height: size.height * 0.05,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                              onPressed: () {}),
                                          IconButton(
                                              icon: Icon(
                                                Icons.share,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                              onPressed: () {}),
                                          IconButton(
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                              onPressed: () {})
                                        ],
                                      ),
                                    ),*/
                                    userOpinionList == null
                                        ? CircularProgressIndicator()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, top: 15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    userOpinionList[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            userAvatarUrlList == null
                                ? CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        //************************CARDAVATAR*****************************
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: userAvatarUrlList == null
                                              ? CircularProgressIndicator()
                                              : ClipOval(
                                                  child: Image.network(
                                                  userAvatarUrlList[index]
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  width: 50.0,
                                                  height: 50.0,
                                                )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            userDiscordTagList[index]
                                                .toString()
                                                .toLowerCase(),
                                            style: TextStyle(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
