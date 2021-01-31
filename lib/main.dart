import 'package:flutter/material.dart';

import 'db/database_helper.dart';
import 'model/person.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sqflite usage',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _bioFocus = FocusNode();
  List<Person> personList = List<Person>();
  int selectedPersonIndex = -1;

  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("sqflite usage"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              key: formKey,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        selectedPersonIndex == -1
                            ? "CREATE PERSON"
                            : "EDIT AND UPDATE ${personList[selectedPersonIndex].name}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Person name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      maxLength: 30,
                      validator: (value) {
                        return value.isEmpty
                            ? "Can not assign empty value!"
                            : null;
                      },
                    ),
                    TextFormField(
                      controller: _bioController,
                      focusNode: _bioFocus,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Person bio",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      maxLength: 100,
                      maxLines: 3,
                      validator: (value) {
                        return value.isEmpty
                            ? "Can not assign empty value!"
                            : null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedPersonIndex == -1
                            ? RaisedButton.icon(
                                elevation: 10,
                                padding: EdgeInsets.all(10),
                                color: Colors.green.shade500,
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    _insert(Person(
                                        _nameController.value.text.toString(),
                                        _bioController.value.text.toString()));
                                    formKey.currentState.reset();
                                    _bioFocus.unfocus();
                                    _nameFocus.unfocus();
                                  }
                                },
                                label: Text(
                                  "CREATE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.save_outlined,
                                  color: Colors.white,
                                ),
                              )
                            : RaisedButton.icon(
                                elevation: 10,
                                padding: EdgeInsets.all(10),
                                color: Colors.yellow.shade900,
                                onPressed: () {
                                  _nameController.text = "";
                                  _bioController.text = "";
                                  _bioFocus.unfocus();
                                  _nameFocus.unfocus();
                                  setState(() {
                                    selectedPersonIndex = -1;
                                  });
                                },
                                label: Text(
                                  "CANCEL",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                              ),
                        RaisedButton.icon(
                          elevation: 10,
                          padding: EdgeInsets.all(10),
                          color: Colors.blue.shade500,
                          onPressed: selectedPersonIndex != -1
                              ? () {
                                  if (formKey.currentState.validate()) {
                                    _update(Person.withID(
                                        personList[selectedPersonIndex].id,
                                        _nameController.value.text.toString(),
                                        _bioController.value.text.toString()));
                                    _nameController.text = "";
                                    _bioController.text = "";
                                    _bioFocus.unfocus();
                                    _nameFocus.unfocus();
                                    setState(() {
                                      selectedPersonIndex = -1;
                                    });
                                  }
                                }
                              : null,
                          label: Text(
                            "UPDATE",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                          ),
                        ),
                        RaisedButton.icon(
                          elevation: 10,
                          padding: EdgeInsets.all(10),
                          color: Colors.red.shade500,
                          onPressed: selectedPersonIndex == -1
                              ? () {
                                  if (personList.length != 0) {
                                    _bioFocus.unfocus();
                                    _nameFocus.unfocus();
                                    _deleteAll();
                                  }
                                }
                              : null,
                          label: Text(
                            "DELETE ALL",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.black,
                      height: 2,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: personList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) {
                      _delete(index);
                    },
                    key: Key(personList[index].id.toString()),
                    direction: DismissDirection.startToEnd,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.yellow.shade900, width: 2)),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              selectedPersonIndex = index;
                              _nameController.text = personList[index].name;
                              _bioController.text = personList[index].bio;
                            });
                          },
                          title: Text(personList[index].name),
                          subtitle: Text(personList[index].bio),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _insert(Person p) async {
    await dbHelper.insert(p.toMap()).then((value) {
      if (value > 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Person created'),
          ),
        );
        setState(() {
          p.id = value;
          personList.add(p);
        });
      }
    });
  }

  void _update(Person p) async {
    await dbHelper.update(p.toMap()).then((value) {
      if (value > 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Person updated'),
          ),
        );
        _query();
      }
    });
  }

  void _query() async {
    personList.clear();
    await dbHelper.queryAllRows().then((value) {
      setState(() {
        value.forEach((row) {
          personList.add(Person.fromMap(row));
        });
      });
    });
  }

  void _delete(index) async {
    await dbHelper.delete(personList[index].id).then((value) {
      if (value > 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Person deleted'),
          ),
        );
        _bioFocus.unfocus();
        _nameFocus.unfocus();
        setState(() {
          if (index == selectedPersonIndex) {
            _nameController.text = "";
            _bioController.text = "";
          }
          selectedPersonIndex = -1;
          personList.removeAt(index);
        });
      } else {
        _query();
      }
    });
  }

  void _deleteAll() async {
    await dbHelper.deleteAllRows().then((value) {
      if (value > 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Deleted all persons'),
          ),
        );
        setState(() {
          personList.clear();
        });
      }
    });
  }
}
