import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smolleytoolbox/options.dart';
import 'package:smolleytoolbox/sqlite.dart';

import '../constants.dart';
import 'home.dart';
import 'onboardingScreen.dart';

class CreateNote extends StatefulWidget {
  final Map note;
  const CreateNote({super.key, required this.note});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final mysqlite = sqlite();
  final options = Options();
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  Color thumb_up = Colors.black;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note.isNotEmpty) {
      title = TextEditingController(text: widget.note['Title']);
      body = TextEditingController(text: widget.note['notes']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background3,
      body: SingleChildScrollView(
        child: Container(
          margin: bmargintop,
          padding: bpadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnBoarding()));
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Create a note ...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.0,
                height: 350.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), color: note1),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          //initialValue: 'Note Title',
                          controller: title,
                          style: TextStyle(fontSize: 20.sp),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: 'Note Title',
                              hintStyle: TextStyle(fontSize: 20),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.create_rounded,
                                color: Colors.black,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: 250.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: TextFormField(
                            controller: body,
                            //initialValue: 'Note Title',
                            //keyboardType: TextInputType.multiline,
                            maxLines: null,
                            //textInputAction: TextInputAction.next,
                            //textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Type to Continue ...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14), // Add spacing or padding here
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter notes';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 25,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            },
                            icon: const Icon(
                              Icons.thumb_down,
                              color: Colors.white,
                            )),
                      ),
                      Text('Dont save')
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: thumb_up,
                        child: IconButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  thumb_up = Colors.green;
                                });
                                if (widget.note.isEmpty) {
                                  final id = await mysqlite.insertdata(
                                      title.text, body.text);
                                  if (id > 0) {
                                    options.displaymessagefromtop(
                                        context, "Note Created", true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  }
                                } else {
                                  await mysqlite.update(widget.note['_id'],
                                      title.text, body.text);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                            )),
                      ),
                      Text('Save')
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
