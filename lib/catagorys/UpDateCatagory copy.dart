import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/catagorys/TextFormfiledAdd.dart';

class UpDatecatagory extends StatefulWidget {
  final String oldName;
  final String docid;
   const UpDatecatagory({super.key,required this.oldName,required this.docid});
  @override
  State<UpDatecatagory> createState() => _UpDatecatagoryState();
}

class _UpDatecatagoryState extends State<UpDatecatagory> {
  TextEditingController name=TextEditingController();
  GlobalKey<FormState> formState=GlobalKey<FormState>();
  
  CollectionReference categories=FirebaseFirestore.instance.collection('categories');
 bool is_Loding=false;
  editCategori()async{
    is_Loding=true;
    setState(() {
      
    });
    if(formState.currentState!.validate()){
      try{
        await categories.doc(widget.docid).update({"Name":name.text});
   
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
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text=widget.oldName;
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
                onPressed: editCategori,
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