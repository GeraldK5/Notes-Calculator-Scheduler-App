import 'package:flutter/material.dart';
import 'package:smolleytoolbox/constants.dart';
import 'package:smolleytoolbox/screens/calendar.dart';
import 'package:smolleytoolbox/screens/home.dart';
import 'package:smolleytoolbox/sqlite.dart';

class Options {
  final mysql = sqlite();

  void displaymessagefromtop(
      BuildContext context, String message, bool success) {
    final Snackbar = SnackBar(
        //behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            success
                ? Icon(Icons.check, color: Colors.white)
                : Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Wrap(children: [
              Text(
                message,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.fade,
              )
            ])),
          ],
        ),
        backgroundColor: success
            ? Color.fromARGB(255, 40, 138, 44)
            : Color.fromARGB(255, 167, 77, 70));
    ScaffoldMessenger.of(context).showSnackBar(Snackbar);
  }

  void deletenotemessage(BuildContext context, int note) {
    showModalBottomSheet(
        backgroundColor: background2,
        elevation: 30,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  ListTile(
                      title: Center(
                          child: Text(
                              "Are you sure you want to delete this Note"))),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Delete")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("Cancel"))
                    ],
                  ),
                ],
              ));
        }).then((value) async {
      if (value != null && value) {
        final record = await mysql.deleterecord(note);
        if (record > 0) {
          displaymessagefromtop(context, "Note Deleted", true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } else {}
    });
  }

  void deleteeventmessage(BuildContext context, int event) {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 185, 181, 181),
        elevation: 30,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  const ListTile(
                      title: Center(
                          child: Text(
                              "Are you sure you want to delete this Event"))),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Delete")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Cancel"))
                    ],
                  ),
                ],
              ));
        }).then((value) async {
      if (value != null && value) {
        final record = await mysql.deleteevent(event);
        if (record > 0) {
          displaymessagefromtop(context, 'Deleted Event', true);
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Calendar()));
      } else {}
    });
  }
}
