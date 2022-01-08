import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crud Operation',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Firestore Example Add User'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextField(controller: controllerName, decoration: decoration("Name")),
          SizedBox(height: 30),
          TextField(
            controller: controllerAge,
            decoration: decoration("Age"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 30),
          DateTimeField(
            controller: controllerDate,
            decoration: decoration("Birthday"),
            format: DateFormat('yyyy-MM-dd'),
            onShowPicker: (context, currentValue) => showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: Text("Create"),
            onPressed: () {
              final user = User(
                name: controllerName.text,
                age: int.parse(controllerAge.text),
                birthday: DateTime.parse(controllerDate.text),
              );
              createUser(user);
            },
          ),
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createUser(User user) async {
    //Reference to database document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    // create document and write data to firebase
    await docUser.set(json);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User created"),
      backgroundColor: Colors.green,
    ));
  }
}

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = "",
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };
}
