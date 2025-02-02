import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/catagorys/UpDateCatagory%20copy.dart';
import 'package:flutter_application_4/note/NotePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
 List data=[];
 bool is_Loding=true;
  GetData()async{
   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('categories').where('id',isEqualTo:  FirebaseAuth.instance.currentUser!.uid).get();
   data.addAll(querySnapshot.docs);
   is_Loding=false;
   setState(() {
     
   });
  }

 

  @override
   void initState()
  {
    GetData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed('Imagepicker');
      },
      child:Icon(Icons.add) ,
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text("appName"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login', (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body:is_Loding?Center(child: CircularProgressIndicator()) :GridView.builder(
        itemCount: data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder:(context,i) {
           return InkWell(
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Notepage(docId: data[i].id,pageName: data[i]['Name'],)));
            },
            onLongPress: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.topSlide,
                title: "Delete",
                desc: "do you wont to delet the Folder",
                btnCancelText: "Delete",
                btnOkText: "Edit",
                btnCancelOnPress: () async{
                  
                  await FirebaseFirestore.instance.collection('categories').doc(data[i].id).delete();
                   Navigator.of(context).pushReplacementNamed('home');

                },
                btnOkOnPress: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpDatecatagory(docid: data[i].id,oldName: data[i]['Name'],)));

                },
                ).show();
            },
             child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.asset('lib/asset/7123025_logo_google_g_icon.png',height: 120,width: 120,),
                    Text("${data[i]['Name']}")
                  ],
                ),
              ),
                       ),
           );
        }
        
         
        
      ),
    );
  }
}
