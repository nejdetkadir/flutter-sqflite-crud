import 'package:flutter/material.dart';

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
  var formKey = GlobalKey<FormState>();
  String selectedSexual = "male";
  String selectedType = "erkek";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "CREATE PERSON",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
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
                      onSaved: (newValue) {
                        print(newValue);
                      },
                    ),
                    TextFormField(
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
                      onSaved: (newValue) {
                        print(newValue);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton.icon(
                          elevation: 10,
                          padding: EdgeInsets.all(10),
                          color: Colors.green.shade500,
                          onPressed: () {},
                          label: Text(
                            "CREATE",
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
                          color: Colors.blue.shade500,
                          onPressed: () {},
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
                          onPressed: () {},
                          label: Text(
                            "DELETE",
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
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.yellow.shade900, width: 2)),
                        child: ListTile(
                          onTap: () {},
                          title: Text("title $index"),
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
}
