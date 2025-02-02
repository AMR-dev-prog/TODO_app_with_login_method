import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/note/UpDateNote.dart';
import 'package:flutter_application_4/note/addNewNote.dart';

class Notepage extends StatefulWidget {
  String docId;
 final String pageName;
   Notepage({super.key,required this.docId,required this.pageName});

  @override
  State<Notepage> createState() => _NotepageState();
}
class _NotepageState extends State<Notepage> {
 List data=[];
 bool is_Loding=true;
  GetData()async{
   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection('Note').get();
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddNewNote(docId:widget.docId ,pageName: widget.pageName,)));
      },
      child:Icon(Icons.add) ,
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text(widget.pageName),
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
      body:StreamBuilder(stream: FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection('Note').snapshots(),
       builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.hasError){
           return Center(child: Text("Error: ${snapshot.error}"));
        }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No notes available."));
            }

            final data=snapshot.data!.docs;

            return GridView.builder(
            itemCount: data.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            itemBuilder: (context,i)
            {
              return InkWell(
               onTap: () async {
                    DocumentReference docRef = FirebaseFirestore.instance
                        .collection('categories')
                        .doc(widget.docId)
                        .collection('Note')
                        .doc(data[i].id);

                    try {
                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(docRef);

                        if (!snapshot.exists) {
                          throw Exception("Document does not exist!");
                        }

                        Map<String, dynamic> docData =
                            snapshot.data() as Map<String, dynamic>;
                        int currentMony = docData['Mony'] ?? 0;
                        transaction.update(docRef, {'Mony': currentMony + 100});
                      });
                    } catch (e) {
                      print("Error updating Mony: $e");
                    }
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      title: "Delete",
                      desc: "Do you want to delete the folder?",
                      btnCancelText: "Delete",
                      btnOkText: "Edit",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection('categories')
                            .doc(widget.docId)
                            .collection('Note')
                            .doc(data[i].id)
                            .delete();
                      },
                      btnOkOnPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpDateNote(
                              docid: data[i].id,
                              olddocid: widget.docId,
                              oldName: data[i]['Name'],
                              pageName: widget.pageName,
                            ),
                          ),
                        );
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/asset/7123025_logo_google_g_icon.png',
                            height: 120,
                            width: 120,
                          ),
                          Text("${data[i]['Name']}"),
                          Text("${data[i]['Mony']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    
  }
}