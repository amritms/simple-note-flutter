import 'package:flutter/material.dart';
import 'package:simple_note/DBHelper.dart';
import 'package:simple_note/mynote.dart';

class NotePage extends StatefulWidget {
  NotePage(this._mynote, this._isNew);

  final Mynote _mynote;
  final bool _isNew;
  bool btnSave;
  bool btnEdit;
  bool btnDelete;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title;
  bool btnSave = false;
  bool btnEdit = true;
  bool btnDelete = true;
  String createdAt;
  Mynote mynote;

  final cTitle = TextEditingController();
  final cNote = TextEditingController();

  var now = DateTime.now();

  bool _enabledTextField = true;

  Future addRecord() async {
    var db = DBHelper();
    String dateNow = "${now.day}-${now.month}-${now.year}, ${now.hour}:${now.minute}";

    var mynote = Mynote(cTitle.text, cNote.text, dateNow, dateNow, dateNow.toString());
    await db.saveNote(mynote);
    print("note saved");
  }

  Future updateRecord() async {
    var db = new DBHelper();
    String dateNow = "${now.day}-${now.month}-${now.year}, ${now.hour}:${now.minute}";
    
    var mynote = new Mynote(cTitle.text, cNote.text, createdAt, dateNow, now.toString());

    mynote.setNodeId(this.mynote.id);
    await db.updateNote(mynote);
  }

  void _saveData(){
    if(widget._isNew){
      addRecord();
    }else{
      updateRecord();
    }

    Navigator.of(context).pop();
  }

  void _editData() {
    setState((){
      _enabledTextField = true;
      btnEdit = false;
      btnSave=true;
      btnDelete=true;
      title="Edit Note";
    });
  }

@override
  void initState() {
    // TODO: implement initState

      if(widget._mynote != null){
        mynote = widget._mynote;
        cTitle.text = mynote.title;
        cNote.text = mynote.note;
        title="My Note";
        _enabledTextField = false;
        createdAt = mynote.createdAt;
      }
      super.initState();
  }

  void delete(Mynote mynote){
    var db = new DBHelper();
    db.deleteNote(mynote);
    print('Note deleted');
  }
  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      content: Text("Are you sure?", style: TextStyle(fontSize: 20.0),),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          child: Text('Ok Delete', style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.pop(context);
            delete(mynote);
            Navigator.pop(context);

          },
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    
    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    if(widget._isNew){
      title = "New Note";
      btnSave = true;
      btnEdit =  false;
      btnDelete = false;
    }
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title, style: TextStyle(color: Colors.black, fontSize: 20.0),)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.black, size: 25.0,),)
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CreateButton(
                  icon: Icons.save,
                  enable: btnSave,
                  onPress: _saveData,
                ),
                CreateButton(
                  icon: Icons.edit,
                  enable: btnEdit,
                  onPress: _editData,
                ),
                CreateButton(
                  icon: Icons.delete,
                  enable: btnDelete,
                  onPress: _confirmDelete,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                enabled: _enabledTextField,
                controller: cTitle,
                decoration: InputDecoration(
                    hintText: "Title",
//                    border: InputBorder.none
                ),
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.grey[800],
                ),
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                enabled: _enabledTextField,
                controller: cNote,
                decoration: InputDecoration(
                    hintText: "Write here...",
//                    border: InputBorder.none
                ),
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.grey[800],
                ),
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ],
        ),
      ),

    );
  }
}


class CreateButton extends StatelessWidget {
  final IconData icon;
  final bool enable;
  final onPress;

  CreateButton({this.icon, this.enable, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: enable ? Colors.lightBlue: Colors.grey),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 18.0,
        onPressed: (){
          if(enable){
            onPress();
          }
        },
      )
    );
  }
}
