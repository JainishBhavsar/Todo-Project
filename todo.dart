import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo_Json'),
        ),
        body: TodoApi(),
      ),
    );
  }
}

class TodoApi extends StatefulWidget {
  const TodoApi({super.key});

  @override
  State<TodoApi> createState() => _TodoApiState();
}

class _TodoApiState extends State<TodoApi> {
  TextEditingController txt = TextEditingController();
  TextEditingController txt1 = TextEditingController();

  void setdata() async {
    try {
      String title = txt.text;
      String details = txt1.text;

      var uri = Uri.https('akashsir.in', '/myapi/crud/todo-add-api.php');
      var response = await http
          .post(uri, body: {'todo_title': title, 'todo_details': details});
      print('Response Status : ${response.statusCode}');
      print('Response Body : ${response.body}');
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: txt,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Title',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: txt1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Details',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                setdata();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tododata()),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class Tododata extends StatefulWidget {
  const Tododata({super.key});

  @override
  State<Tododata> createState() => _TododataState();
}

class _TododataState extends State<Tododata> {
  Future? mydata;
  var mydatalist = [];

  Future<List> fetchData() async {
    try {
      var url = Uri.https('akashsir.in', '/myapi/crud/todo-list-api.php');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> mymap = json.decode(response.body);
      mydatalist = mymap['todo_list'];

      return mydatalist;
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    mydata = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: mydata,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Somthing went wrong'));
        return Scaffold(
          body: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Text(
                      'ID : ${snapshot.data[index]['todo_id'].toString()}'),
                  title: Text(
                      'Username : ${snapshot.data[index]['todo_title'].toString()}'),
                  subtitle: Text(
                      'Name : ${snapshot.data[index]['todo_details'].toString()}'),
                  trailing: Text(
                      'Time : ${snapshot.data[index]['todo_datetime'].toString()}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
