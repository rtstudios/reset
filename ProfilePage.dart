import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var activityCards = [];
  
  void showContent() {
    showDialog(
      context: context, barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          title: Text('Erase Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('All of your data on this app is about to be erased. Any content that you submitted will NOT be deleted.'),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ERASE'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("firstLogin");
                prefs.remove("name");
                prefs.remove("mindfulnessMinutes");
                prefs.remove("recentActivity");

                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
          ],
        );
      },
    );
  }

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "?";
    });
  }

  getMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mindfulnessMinutes = prefs.getDouble("mindfulnessMinutes") ?? 0.0;
    });
  }

  getActivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var recentTitles = prefs.getString("recentTitles") ?? "";
    var recentDurations = prefs.getString("recentDurations") ?? "";
    var recentTitlesList = recentTitles.split(",");
    var recentDurationsList = recentDurations.split(",");

    for(var i = 0; i < recentTitlesList.length; i++) {
      activityCards.add(ActivityCard(recentTitlesList[i], recentDurationsList[i]));
    }
    
    activityCards.removeLast();
  }

  @override
  void initState() {
    super.initState();
    getName();
    getMinutes();
    getActivity();
  }

  var name = "";
  var mindfulnessMinutes = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage("lib/assets/river.jpeg"),
              fit: BoxFit.fitWidth,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.75), BlendMode.dstATop
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Text(
                  mindfulnessMinutes.round().toString() + " MINDFULNESS MINUTES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 33,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        for(var i = 0; i < activityCards.length; i++) activityCards[i],
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(50),
            ),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 47,
              child: Text(
                "Clear Activity",
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
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString("recentTitles", "");
                  prefs.setString("recentDurations", "");
                  activityCards.clear();
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.redAccent,
                    Colors.red,
                  ]),
              borderRadius: BorderRadius.circular(50),
            ),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 47,
              child: Text(
                "Erase Data",
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
              onPressed: showContent,
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String duration;

  ActivityCard(this.title, this.duration);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color.fromARGB(255, 112, 111, 211),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
              child: Text(
                this.title,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                this.duration,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
