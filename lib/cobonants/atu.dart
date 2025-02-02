import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String imagePath;
  void Function()? onTap;
   MyButton({super.key, required this.imagePath,required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          
          ),
        child: SizedBox(height:double.infinity,width: double.infinity,child:  Image.asset(imagePath, fit: BoxFit.fill,width: 50,height: 50,)),
      ),
    );
  }
}