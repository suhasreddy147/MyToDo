import 'package:flutter/material.dart';
import 'package:todo_app/dbhelper.dart';

class ToDoUI extends StatefulWidget{
  @override
  ToDoUIState createState() => ToDoUIState();
}

class ToDoUIState extends State<ToDoUI>{

  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();

  void addToDO() async{
    Map<String, dynamic> row = {
      Databasehelper.columnName : todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited="";
    setState(() {
      validated=true;
      errtext="";
    });
  }

  Future<bool> query() async{
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row){
      myitems.add(row.toString());
      children.add( Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Raleway",
              ),
            ),
            onLongPress: (){
              dbhelper.deletedata(row['id']);
              setState(() {
                
              });
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showAlertDialog(){
    texteditingcontroller.text = "";
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val){
                      todoedited = _val;
                    },
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.teal,
                          onPressed: (){
                            if(texteditingcontroller.text.isEmpty){
                              setState((){
                                errtext="Can't Be Empty";
                                validated=false;
                              });
                            }
                            else if(texteditingcontroller.text.length > 512){
                              setState((){
                                errtext="Can't Be More than 512 characters";
                                validated=false;
                              });
                            }
                            else{
                              addToDO();
                            }
                          },
                          child: Text(
                            "ADD",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
  
 /* Widget mycard(String task){
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(
            "$task",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Raleway",
            ),

          ),
          onLongPress: (){
            print("Should Get Deleted");
          },
        ),
      ),
    );
  }
  */
  
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      builder: (context, snap){
        if(snap.hasData == null){
          return Center(
            child: Text(
              "No Data",
            ),
          );
        }
        else{
          if(myitems.length == 0){
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showAlertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              backgroundColor: Colors.black,
              body:  Center(
                child: Text(
                  "No Task Available",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            );
          }
          else{
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showAlertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}


/*
  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAlertDialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
      ),
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: TextStyle(
            fontFamily: "Raleway",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            mycard("Record A video"),
          ],
        ),
      ),
    );
*/