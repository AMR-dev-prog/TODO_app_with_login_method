import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/note/NotePage.dart';

class UpDateNote extends StatefulWidget {
  final String oldName;
  final String docid;
  final String olddocid;
  final String pageName;

  const UpDateNote({
    super.key,
    required this.oldName,
    required this.docid,
    required this.pageName,
    required this.olddocid,
  });

  @override
  State<UpDateNote> createState() => _UpDateNoteState();
}

class _UpDateNoteState extends State<UpDateNote> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool is_Loding = false;

  Future<void> editCategori() async {
    if (!formState.currentState!.validate()) return;

    setState(() {
      is_Loding = true;
    });

    CollectionReference categories = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.olddocid)
        .collection('Note');

    try {
      await categories.doc(widget.docid).update({"Name": name.text});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note updated successfully!')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Notepage(
            docId: widget.olddocid,
            pageName: widget.pageName,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        is_Loding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating note: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        centerTitle: true,
      ),
      body: is_Loding
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
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
              ),
            ),
    );
  }
}
