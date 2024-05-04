import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/database/database.dart';
import 'package:todo/main.dart';

import 'database/model.dart';

class completedpage extends StatefulWidget {
  List<task> t;
  completedpage({Key? key, required this.t}) : super(key: key);

  @override
  State<completedpage> createState() => _completedpageState();
}

class _completedpageState extends State<completedpage> {
  late List<task> t;
  @override
  Widget build(BuildContext context) {
    refresh() {}

    t = widget.t;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Completed Task"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                    itemCount: t.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                repo r = repo();

                                setState(() {
                                  r.deletedata("task", t[index].id);
                                  t.removeAt(index);
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => todoapp()));
                                SnackBar s =
                                    SnackBar(content: Text("Task Removed"));
                                ScaffoldMessenger.of(context).showSnackBar(s);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                repo r = repo();
                                task temp = task(
                                    id: t[index].id,
                                    title: t[index].title,
                                    description: t[index].description,
                                    status: "no");
                                setState(() {
                                  r.updatedata("task", temp.mapping());
                                  t.removeAt(index);
                                });
                                Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => todoapp()))
                                    .then((value) => setState(() {}));
                                SnackBar s = SnackBar(
                                    content: Text("Task Moved to completed"));
                                ScaffoldMessenger.of(context).showSnackBar(s);
                              },
                              icon: Icons.undo,
                              backgroundColor: Colors.blue,
                              label: "Incomplete",
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ListTile(
                              title: Text(
                                t[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              subtitle: Text(t[index].description),
                            ),
                          ),
                        ),
                      );
                    }),
              ))
            ],
          ),
        ));
    ;
  }
}
