import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_app/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool today = true, tomorrow = false, nextweek = false;
  bool suggest = false;
  Stream? todoStream;

  getontheload() async {
    todoStream = await DatabaseMethods().getalltheWork(today
        ? "Today"
        : tomorrow
            ? "Tomorrow"
            : "Next Week");
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return CheckboxListTile(
                        activeColor: Colors.lightBlue,
                        title: Text(
                          ds["Work"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        value: ds["Yes"],
                        onChanged: (newValue) async {
                          await DatabaseMethods().updateifTicked(
                              ds["Id"],
                              today
                                  ? "Today"
                                  : tomorrow
                                      ? "Tomorrow"
                                      : "Next Week");
                          setState(() {});
                        },
                        controlAffinity: ListTileControlAffinity.leading);
                  })
              : CircularProgressIndicator();
        });
  }

  TextEditingController todocontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.lightBlue,
          size: 30.0,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          (Colors.lightGreen),
          (Colors.lightBlue),
          (Colors.deepOrange)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notes checker",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              "Good Morning",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                today
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Today",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = true;
                          tomorrow = false;
                          nextweek = false;
                          await getontheload();
                          setState(() {});
                        },
                        child: Text(
                          "Today",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                tomorrow
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Tomorrow",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = false;
                          tomorrow = true;
                          nextweek = false;
                          await getontheload();
                          setState(() {});
                        },
                        child: Text(
                          "Tomorrow",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                nextweek
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Next Week",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          today = false;
                          tomorrow = false;
                          nextweek = true;
                          await getontheload();
                          setState(() {});
                        },
                        child: Text(
                          "Next Week",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 20),
            allWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        SizedBox(width: 30),
                        Text(
                          "Add the notes",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Add Text"),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: todocontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Enter Text"),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        String id = randomAlphaNumeric(10);
                        Map<String, dynamic> userTodo = {
                          "Work": todocontroller.text,
                          "Id": id,
                          "Yes": false,
                        };
                        today
                            ? DatabaseMethods().addTodayWork(userTodo, id)
                            : tomorrow
                                ? DatabaseMethods()
                                    .addTomorrowWork(userTodo, id)
                                : DatabaseMethods()
                                    .addNextWeekWork(userTodo, id);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text("Add",
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
