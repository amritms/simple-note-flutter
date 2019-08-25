import 'package:flutter/material.dart';
import 'package:simple_note/DBHelper.dart';
import 'package:simple_note/NoteList.dart';
import 'package:simple_note/NotePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = new DBHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Container(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("img/note-icon.png")),
        title: Text("Simple Notes", style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w300)),
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new NotePage(null, true))),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
          }
          var data = snapshot.data;

          return snapshot.hasData ? new NoteList(data) : Center(child: Text("No Data"),);
        },
      )
    );
  }
}
