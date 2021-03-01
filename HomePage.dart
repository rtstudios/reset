import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './SetAssets.dart';
import './Quote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  var json = [];
  List<Widget> focusSets = <Widget>[];
  List<Widget> relaxSets = <Widget>[];
  List<Widget> stressSets = <Widget>[];

  void getAllSets() {
    databaseReference.child("Focus").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
        values.forEach((values) {
          setState(() {
            json.add(values);
            json.remove(null);
            for(int i = 0; i < json.length; i++) {
              focusSets.add(StandardSet(json[i]["title"].toString(), json[i]["description"].toString(), json[i]["duration"].toString(), json[i]["imagePath"].toString(), json[i]["audioUrl"].toString()));
            }
            json.clear();
          });
        }
      );
    });
    databaseReference.child("Relax").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
        values.forEach((values) {
          setState(() {
            json.add(values);
            json.remove(null);
            for(int i = 0; i < json.length; i++) {
              relaxSets.add(StandardSet(json[i]["title"].toString(), json[i]["description"].toString(), json[i]["duration"].toString(), json[i]["imagePath"].toString(), json[i]["audioUrl"].toString()));
            }
            json.clear();
          });
        }
      );
    });
    databaseReference.child("Stress").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
        values.forEach((values) {
          setState(() {
            json.add(values);
            json.remove(null);
            for(int i = 0; i < json.length; i++) {
              stressSets.add(StandardSet(json[i]["title"].toString(), json[i]["description"].toString(), json[i]["duration"].toString(), json[i]["imagePath"].toString(), json[i]["audioUrl"].toString()));
            }
            json.clear();
          });
        }
      );
    });
  }

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("name") ?? "";
    setState(() {
      firstName = name.split(" ").removeAt(0);      
    });
  }

  void getTime() {
    var timeOfDay = DateTime.now().hour;

    if(timeOfDay < 12) {
      setState(() {
        timeString = "Good morning, ";
      });
    } 
    else if(timeOfDay > 17) {
      setState(() {
        timeString = "Good evening, ";
      });
    }
    else {
      setState(() {
        timeString = "Good afternoon, ";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSets();
    getTime();
    getName();
  }

  var timeString = "";
  var firstName = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.32,
              color: Colors.blueGrey,
              child: Image(
                image: AssetImage("lib/assets/leaf.jpeg"),
                fit: BoxFit.fitWidth,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    timeString + firstName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Quote(),
                Author(),
              ],
            ),
          ],
        ),
        CategoryTitle("Focus"),
        HorizontalList([
          for(int i = 0; i < focusSets.length; i++) focusSets[i]
        ]),

        CategoryTitle("Relax"),
        HorizontalList([
          for(int i = 0; i < relaxSets.length; i++) relaxSets[i]
        ]),

        CategoryTitle("Stress"),
        HorizontalList([
          for(int i = 0; i < stressSets.length; i++) stressSets[i]
        ]),
      ]),
    );
  }
}
