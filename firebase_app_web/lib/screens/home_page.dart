import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/screens/profile_page.dart';
import 'package:firebase_app_web/screens/signUp_page.dart';
import 'package:firebase_app_web/screens/todo_card_page.dart';
import 'package:firebase_app_web/screens/view_data.dart';
import 'package:firebase_app_web/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../utilities/image.dart';
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.id}) : super(key: key);
  final String id;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];

  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Text("Today's Schedule"),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => const ProfilePage()));
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/mavioguz.jpg'),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                IconData iconData;
                Color iconColor;
                Map<String, dynamic> document =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                switch (document["category"]) {
                  case "Run":
                    iconData = Icons.run_circle;
                    iconColor = Colors.green;

                    break;
                  case "Food":
                    iconData = Icons.local_grocery_store;
                    iconColor = Colors.lightBlue;
                    break;
                  case "Design":
                    iconData = Icons.audiotrack;
                    iconColor = Colors.black87;
                    break;
                  case "Work":
                    iconData = Icons.work_outline_rounded;
                    iconColor = Color.fromARGB(255, 75, 34, 19);
                    break;
                  case "WorkOut":
                    iconData = Icons.alarm_add_outlined;
                    iconColor = Colors.red;
                    break;
                }
                selected.add(Select(
                  id: snapshot.data.docs[index].id,
                  checkValue: false,
                ));
                return InkWell(
                  onTap: () {
                    if (selected[index].checkValue == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ViewDataPage(
                            document: document,
                            id: snapshot.data.docs[index].id,
                          ),
                        ),
                      );
                    }
                  },
                  child: TodoCard(
                    title: document["title"] == null
                        ? "Hey There"
                        : document["title"],
                    check: selected[index].checkValue,
                    iconBgColor: Colors.yellowAccent,
                    iconColor: iconColor,
                    iconData: iconData,
                    time: "10 AM ",
                    index: index,
                    onChange: onChange,
                  ),
                );
              });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.amber,
                      ],
                    )),
                child: const Icon(
                  Icons.home,
                  size: 32,
                  color: Color(0xFF420DE4),
                ),
              ),
            ),
            label: '', //home simgesi

            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddTodoPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 250, 238, 10),
                        Color.fromARGB(255, 170, 3, 164),
                      ],
                    )),
                child: const Icon(
                  Icons.add_circle,
                  size: 48,
                  color: Color(0xFF420DE4),
                ),
              ),
            ), //home simgesi
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ProfilePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.amber,
                      ],
                    )),
                child: const Icon(
                  Icons.settings,
                  size: 32,
                  color: Color(0xFF420DE4),
                ),
              ),
            ), //home simgesi
            label: '',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({this.id, this.checkValue});
}

// IconButton(
//           icon: const Icon(Icons.logout),
//           onPressed: () async {
//             await authClass.logout();
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (builder) => const SignUpPage()),
//                 (route) => false);
//           })
