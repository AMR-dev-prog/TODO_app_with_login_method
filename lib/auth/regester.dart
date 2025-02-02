import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/cobonants/buildLabel.dart';
import 'package:flutter_application_4/cobonants/buildTextField.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userName = TextEditingController();

  void onSignIn()async {
  try {
  // ignore: unused_local_variable
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    
  Navigator.of(context).pushReplacementNamed('login');
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
 AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: "Email Verification",
      desc: 'we will send a link to Verifi your Email ',
      btnOkOnPress:(){} 
    
    ).show();
    
  }

  void onForgotPassword() {
    // Navigate to forgot password screen
    print("Forgot password tapped");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueGrey[100],
                    ),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 74,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'regster page',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                'Create account',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildLabel(text: "User Name"),
              BuildTextField(
              controller: userName,
              hintText: "Enter your user Name",
              obscureText: false,
              ),
              SizedBox(height: 25),
              buildLabel(text: "Email"),
              BuildTextField(
                controller:emailController,
                hintText: "enter your email",
                obscureText: false,                
                ),
              SizedBox(height: 25),
              buildLabel(text: "Password"),
              BuildTextField(
                  controller: passwordController,
                  hintText:  "Enter your password",
                  obscureText: true, 
                  suffixIcon: Icons.remove_red_eye),
                   
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onForgotPassword,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              MaterialButton(
                color: Colors.blue,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: onSignIn,
                child: Text(
                  'Regster',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "you have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacementNamed('login');
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blue[300]),
                    ),
                  ),
                ],
              ),
             
            
            ],
          ),
        ),
      ),
    );
  }

 

 
}


 