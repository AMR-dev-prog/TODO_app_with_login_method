import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({super.key});

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  File ? file;
  GetImage()async
  {
    final ImagePicker picker= ImagePicker();
    final XFile? imagecamera=
    await picker.pickImage(source: ImageSource.camera);
    file=File(imagecamera!.path);
    setState(() { });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('image picker'),
      ),
    body: SizedBox(
      width: double.infinity,
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(file!=null)
          Image.file(file!),

         
          FloatingActionButton(onPressed: GetImage),
        ],
      ),
    ),
    );
  }
}