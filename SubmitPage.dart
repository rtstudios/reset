import 'dart:math';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './SetAssets.dart';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  var json = [];
  List<Widget> featuredSets = <Widget>[];
  List<Widget> allSets = <Widget>[];

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController urlController = new TextEditingController();

  var title = "";
  var description = "";
  var url = "";

  void getAllSets() {
    databaseReference.child("Featured").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
        values.forEach((values) {
          setState(() {
            json.add(values);
            json.remove(null);
            for(int i = 0; i < json.length; i++) {
              featuredSets.add(StandardSet(json[i]["title"].toString(), json[i]["description"].toString(), json[i]["duration"].toString(), json[i]["imagePath"].toString(), json[i]["audioUrl"].toString()));
            }
            json.clear();
          });
        }
      );
    });
    databaseReference.child("All").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
        values.forEach((values) {
          setState(() {
            json.add(values);
            json.remove(null);
            for(int i = 0; i < json.length; i++) {
              allSets.add(StandardSet(json[i]["title"].toString(), json[i]["description"].toString(), json[i]["duration"].toString(), json[i]["imagePath"].toString(), json[i]["audioUrl"].toString()));
            }
            json.clear();
          });
        }
      );
    });
  }

  void submitSet() async {
    final random = new Random();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    String randomString() => String.fromCharCodes(Iterable.generate(
      15, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

    if(title.isNotEmpty && description.isNotEmpty && url.isNotEmpty) {
      databaseReference.child("Submitted").child(randomString()).set({
        "name": prefs.getString("name") ?? "?",
        "title": title,
        "description": description,
        "audioUrl": url,
      });
      showContent("Submission Successful", "Your submission will be reviewed.", "CLOSE");
    }
    else {
      showContent("Submission Failed", "One or more fields were empty. Please try again.", "CLOSE");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSets();
  }

  void showContent(title, description, actionButtonText) {
    showDialog(
      context: context, barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(description),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text(actionButtonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.53,
                color: Colors.blueGrey,
                child: Image(
                  image: AssetImage("lib/assets/forest.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 7),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(
                      "SUBMIT YOUR OWN AUDIO SCRIPTS!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SubmitTextField("Title", "What's the title?", titleController, (value) {
                    setState(() {
                      title = value;
                    });
                  }),
                  SubmitTextField("Description", "What's it about?", descriptionController, (value) {
                    setState(() {
                      description = value;
                    });
                  }),
                  SubmitTextField("URL", "Attach the Audio URL.", urlController, (value) {
                    setState(() {
                      url = value;
                    });
                  }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 84, 159, 110),
                              Color.fromARGB(255, 111, 211, 126)
                            ]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 47,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: submitSet,
                        onLongPress: () {
                          showContent("Audio Submission", "To submit an audio script, upload a YouTube video of your audio and put the link in the URL field. Then, give your submission a title and description. Your submission should be at least one minute, but no longer than five minutes.", "CLOSE");
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(
                      "LONG PRESS THE SUBMIT BUTTON FOR MORE INFO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          CategoryTitle("Featured"),
          HorizontalList([
            for(int i = 0; i < featuredSets.length; i++) featuredSets[i]
          ]),

          CategoryTitle("All"),
          HorizontalList([
            for(int i = 0; i < allSets.length; i++) allSets[i]
          ]),
        ],
      ),
    );
  }
}

class SubmitTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function onChangedFunction;

  SubmitTextField(this.label, this.hint, this.controller, this.onChangedFunction);

  @override
  _SubmitTextFieldState createState() => _SubmitTextFieldState();
}

class _SubmitTextFieldState extends State<SubmitTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,          
        ),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: widget.label,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: "Avenir",
              fontSize: 17,
              color: Color.fromARGB(175, 255, 255, 255),
            ),
          ),
          style: TextStyle(
            fontFamily: "Avenir",
            fontSize: 17,
            color: Colors.white,
          ),
          onChanged: widget.onChangedFunction,
        ),
      ),
    );
  }
}
