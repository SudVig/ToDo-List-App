import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/database/model.dart';
import 'package:todo/main.dart';

class updatepage extends StatefulWidget {
  final task t;
  updatepage({Key? key, required this.t}) : super(key: key);

  @override
  State<updatepage> createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {
  TextEditingController txttitle = TextEditingController();
  TextEditingController txtdescription = TextEditingController();
  int? txtid;

  @override
  void initState() {
    setState(() {
      txttitle.text = widget.t.title;
      txtdescription.text = widget.t.description;
      txtid = widget.t.id;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            const Text(
              "Update Your Task",
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
                onPressed: () {
                  task t = task(
                      title: txttitle.text, description: txtdescription.text);
                  t.id = txtid;

                  repo r = repo();
                  r.updatedata("task", t.mapping());
                  final snackbar = SnackBar(
                    content: Text(
                      "Task Updated",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    duration: Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => todoapp()))
                      .then((value) => setState(() {}));
                },
                child: Text("Update"),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
