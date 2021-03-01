import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = new TextEditingController();
  var name = "";

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

  isFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var firstLogin = prefs.getBool("firstLogin") ?? true;

    if(!firstLogin) {
      Navigator.of(context).pushReplacementNamed("/home");
    }
    else {
      prefs.setString("recentTitles", "");
      prefs.setString("recentDurations", "");
      prefs.setDouble("mindfulnessMinutes", 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    isFirstLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            height: MediaQuery.of(context).size.height * 1,
            image: AssetImage(
              "lib/assets/leaf.jpeg",
            ),
            fit: BoxFit.fitHeight,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 100, 25, 25),
                  child: Text(
                    "Welcome to \n ReSet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: "Avenir",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 65),
                  child: Text(
                    "A MINDFULNESS APP DESIGNED FOR STUDENTS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Text(
                    "Please enter your name below",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: "Avenir"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    width: 400,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(94, 142, 142, 142),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Text(
                            "MY NAME IS...",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "John Doe",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(175, 255, 255, 255),
                                fontSize: 40,
                                fontFamily: "Avenir",
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: "Avenir",
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [Color.fromARGB(255, 84, 159, 110), Color.fromARGB(255, 111, 211, 126)]
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        if(name.isNotEmpty && name.length > 6 && name.contains(" ")) {
                          prefs.setString("name", name);
                          prefs.setBool("firstLogin", false);
                          Navigator.of(context).pushReplacementNamed("/home");
                        }
                        else {
                          showContent("Account Creation Failed", "Please enter your full name.", "CLOSE");
                        }
                      },
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "AN APP MADE BY RIFAT TARAFDER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Avenir"
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
