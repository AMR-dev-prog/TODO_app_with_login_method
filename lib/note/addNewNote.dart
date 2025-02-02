import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/catagorys/TextFormfiledAdd.dart';
import 'package:flutter_application_4/note/NotePage.dart';

class AddNewNote extends StatefulWidget {
  final String docId;
  final String pageName;
   const AddNewNote({super.key,required this.docId,required this.pageName});
  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController notename=TextEditingController();
  TextEditingController notemony=TextEditingController();
  GlobalKey<FormState> formState=GlobalKey<FormState>();
  
  
 bool is_Loding=false;
  addNote()async{
    CollectionReference note=FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection('Note');
    is_Loding=true;
    setState(() {
      
    });
    if(formState.currentState!.validate()){
      try{
        DocumentReference response=await note.add({"Name":notename.text,"mony":int.tryParse( notemony.text)});
   
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Notepage(docId: widget.docId,pageName: widget.pageName,)));

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
        child: Text('Add New Note'),
      ),),
      
      body:is_Loding?Center(child: CircularProgressIndicator()): Form(
        key:formState ,
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              BuildTextFieldAdd(hintText: 'Name',controller:notename ,),
              SizedBox(height: 50,),
              BuildTextFieldAdd(hintText: 'Mony',controller:notemony ,),
              SizedBox(height: 50,),
            MaterialButton(
                color: Colors.blue,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: addNote,
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