import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/catagorys/TextFormfiledAdd.dart';

class Addnewcatagory extends StatefulWidget {
   const Addnewcatagory({super.key});
  @override
  State<Addnewcatagory> createState() => _AddnewcatagoryState();
}

class _AddnewcatagoryState extends State<Addnewcatagory> {
  TextEditingController name=TextEditingController();
  GlobalKey<FormState> formState=GlobalKey<FormState>();
  
  CollectionReference categories=FirebaseFirestore.instance.collection('categories');
 bool is_Loding=false;
  addCategori()async{
    is_Loding=true;
    setState(() {
      
    });
    if(formState.currentState!.validate()){
      try{
        DocumentReference response=await categories.add({"Name":name.text,'id':FirebaseAuth.instance.currentUser!.uid});
   
        Navigator.of(context).pushNamedAndRemoveUntil('home',(route)=> false);
      }
      catch(e)
      {
             is_Loding=false;
    setState(() {
      
    });
        print("Erorr $e");
      }
    }
  }
  @override
 
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Text('Add New Catagory'),
      ),),
      
      body:is_Loding?Center(child: CircularProgressIndicator()): Form(
        key:formState ,
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              BuildTextFieldAdd(hintText: 'Name',controller:name ,),
              SizedBox(height: 50,),
            MaterialButton(
                color: Colors.blue,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: addCategori,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) 
        ),
    );
  }
}