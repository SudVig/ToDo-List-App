import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/add.dart';
import 'package:todo/completed.dart';
import 'package:todo/database/database.dart';
import 'package:todo/database/model.dart';
import 'package:todo/update.dart';

MaterialColor m = MaterialColor(0xFF2196F3, {900: Color(0xFF0D47A1)});
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.blue[900],
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.blue[900]),
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue[900]),
      buttonTheme: ButtonThemeData(buttonColor: Colors.blue[900]),
    ),
    debugShowCheckedModeBanner: false,
    home: splash(),
  ));
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  late SlidableController sl;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const todoapp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              "ToDo List",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      ),
    );
    ;
  }
}

class todoapp extends StatefulWidget {
  const todoapp({Key? key}) : super(key: key);

  @override
  State<todoapp> createState() => _todoappState();
}

class _todoappState extends State<todoapp> {
  repo r = repo();

  List<task> found = [], fixed = [], completed = [], found1 = [];
  updatelist() async {
    fixed = [];
    completed = [];
    List<Map<String, dynamic>> result = await r.selectdata("task", "no");
    result.forEach((element) {
      task temp = task(
          id: element['id'],
          title: element['title'],
          description: element['description'],
          status: element['status']);

      fixed.add(temp);
    });

    result = await r.selectdata("task", "yes");
    result.forEach((element) {
      task temp = task(
          id: element['id'],
          title: element['title'],
          description: element['description'],
          status: element['status']);

      print(element['status']);

      completed.add(temp);
    });

    setState(() {
      found1 = completed;
      found = fixed;
    });
  }

  search(value) {
    List<task> result = [];

    setState(() {
      if (value.isEmpty) {
        result = fixed;
      } else {
        result = fixed
            .where((element) =>
                element.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      found = result;
    });
  }

  @override
  void initState() {
    updatelist();
    super.initState();
  }

  bool choice = false;

  @override
  Widget build(BuildContext context) {
    confirmationbox(
        BuildContext context, String message, String title, int index) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        repo r = repo();
                        r.deletedata("task", found[index].id);
                        found.removeAt(index);
                      });

                      Navigator.pop(context);
                      final snackbar = SnackBar(content: Text("Task Deleted"));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    )),
              ],
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              updatelist();
            });
            return Future.delayed(Duration(seconds: 0));
          },
          child: Column(children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Tasks",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40.0),
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[300],
                      ),
                      onChanged: (value) => search(value),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "\t${found1.length}/${(fixed.length + completed.length)} Completed"),
                        Align(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            completedpage(t: completed)));
                              },
                              child: Text("Completed Tasks")),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (found.isNotEmpty) ...[
                      Expanded(
                          child: SlidableAutoCloseBehavior(
                        child: ListView.builder(
                            itemCount: found.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                startActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        confirmationbox(
                                            context,
                                            "Do You Want To Delete?",
                                            "Delete",
                                            index);
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                      label: "Delete",
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    updatepage(
                                                      t: found[index],
                                                    )));
                                      },
                                      icon: Icons.edit,
                                      backgroundColor: Colors.blue,
                                      label: "Edit",
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        repo r = repo();
                                        setState(() {
                                          found[index].status = "yes";
                                          task t = found[index];

                                          r.updatedata("task", t.mapping());
                                          updatelist();
                                        });
                                      },
                                      icon: Icons.check_circle_outline,
                                      backgroundColor: Colors.green,
                                      label: "Completed",
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(
                                        found[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      subtitle: Text(found[index].description),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ))
                    ] else ...[
                      Center(
                          child: Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              height: 40.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
              ),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => add()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[900],
          elevation: 10.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }
}
