import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/database/model.dart';
import 'package:todo/main.dart';

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController txttitle = TextEditingController();
  TextEditingController txtdescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            const Text(
              "Add Your Task",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: txttitle,
              decoration: InputDecoration(
                hintText: "Enter your Title",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: txtdescription,
              decoration: InputDecoration(
                hintText: "Enter your Description",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                onPressed: () async {
                  if (txttitle.text.isNotEmpty &
                      txtdescription.text.isNotEmpty) {
                    task t = task(
                        title: txttitle.text, description: txtdescription.text);

                    repo r = repo();
                    r.inserdata("task", t.mapping());

                    final snackbar = SnackBar(
                      content: Text(
                        "Task added",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => todoapp()))
                        .then((value) => setState(() {}));
                  }
                },
                child: Text("Add"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
