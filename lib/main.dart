import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/PAGES/home.dart';
import 'package:flutter_application_4/auth/login.dart';
import 'package:flutter_application_4/auth/regester.dart';
import 'package:flutter_application_4/catagorys/addNewCatagory.dart';
import 'package:flutter_application_4/note/imagePicker.dart';
import 'package:flutter_application_4/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges()
    .listen(
      (User?user){
        if(user!=Null){
          print("++++++++++++++++++++++Logged in+++++++++++++");
        }else{
          print("----------------------------not Logged in");
        }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (FirebaseAuth.instance.currentUser!=null && FirebaseAuth.instance.currentUser!.emailVerified)? Home():Login(),
      routes: {
        'Register':(context)=>Register(),
        'home':(context)=>Home(),
        'login':(context)=>Login(),
        'Addnewcatagory':(context)=>Addnewcatagory(),
        "Imagepicker":(context)=>Imagepicker()
        
        
      },
    );
  }
}
/*
 (FirebaseAuth.instance.currentUser!=null && FirebaseAuth.instance.currentUser!.emailVerified)? Home():Login(),
      routes: {
        'Register':(context)=>Register(),
        'home':(context)=>Home(),
        'login':(context)=>Login(),
        'Addnewcatagory':(context)=>Addnewcatagory(),
        "Imagepicker":(context)=>Imagepicker()
        
        
      },
 */