import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_4/cobonants/atu.dart';
import 'package:flutter_application_4/cobonants/buildLabel.dart';
import 'package:flutter_application_4/cobonants/buildTextField.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isloding = false;

  void onSignIn() async {
    if (formState.currentState!.validate()) {
      try {
        // Firebase authentication
        _isloding=true;
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Navigate to home
        Navigator.of(context).pushReplacementNamed('home');
        _isloding=false;

      } on FirebaseAuthException catch (e) {
  String title = 'Error';
  String description = 'An unknown error occurred.';
  DialogType dialogType = DialogType.error;

  print('FirebaseAuthException code: ${e.code}'); // Debug log

  switch (e.code) {
    case 'user-not-found':
      title = 'User Not Found';
      description = 'No user found for the entered email.';
      dialogType = DialogType.warning;
      break;
    case 'wrong-password':
      title = 'Wrong Password';
      description = 'The password entered is incorrect.';
      dialogType = DialogType.warning;
      break;
    case 'invalid-email':
      title = 'Invalid Email';
      description = 'The email address is not valid.';
      dialogType = DialogType.warning;
      break;
    case 'user-disabled':
      title = 'User Disabled';
      description = 'This user account has been disabled.';
      dialogType = DialogType.warning;
      break;
    default:
      description = 'Error Code: ${e.code}'; // Provide more details
      break;
  }

  showAwesomeDialog(dialogType, title, description);
} catch (e) {
  // Debug unexpected errors
  showAwesomeDialog(DialogType.error, 'Unexpected Error',
      'Something went wrong. Please try again later.');
}

    } else {
      print('Validation failed.');
    }
  }
Future signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception('Sign-in aborted by user');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, navigate to the home page
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed('home');
  } catch (e) {
    print('Google Sign-In failed: $e');
    showAwesomeDialog(DialogType.error, 'Google Sign-In Error', e.toString());
  }
}

  void showAwesomeDialog(DialogType dialogType, String title, String description) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }

  void onTapToRegister(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('Register');
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isloding?
      CircularProgressIndicator()
      : Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
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
                    child: const Icon(
                      Icons.account_circle_rounded,
                      size: 74,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'Login',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enter your personal info',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
            Form(
  key: formState,
  child: Column(
    children: [
      buildLabel(text: "Email"),
      BuildTextField(
        controller: emailController,
        hintText: "Enter your email",
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Email is required.';
          }
          return null;
        },
      ),
      const SizedBox(height: 25),
      buildLabel(text: "Password"),
      BuildTextField(
        controller: passwordController,
        hintText: 'Password',
        obscureText: !_isPasswordVisible,
        suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Password is required.';
          }
          return null;
        },
        onSuffixIconTap: () {
          setState(() {
            

          _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    ],
  ),
),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async{
                      if(emailController.text =='')
                      {
                      showAwesomeDialog(DialogType.warning,"reset pass word","plase enter the email");

                        return ;
                      }
                      try{
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                      showAwesomeDialog(DialogType.success,"reset pass word","we send a link to your Email to reset password");

                      }catch(e){
                        print(e.toString());
                      }

                    },
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
              const SizedBox(height: 25),
              MaterialButton(
                color: Colors.blue,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: onSignIn,
                child: const Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 2)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Fast login",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 2)),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 MyButton(
                 onTap: () => signInWithGoogle(context), // Pass the BuildContext here
                  imagePath: 'lib/asset/7123025_logo_google_g_icon.png',
),

                  const SizedBox(width: 25),
                  MyButton(
                    onTap: (){},
                    imagePath: 'lib/asset/apple-logo-1-2.png'),
                  const SizedBox(width: 25),
                  MyButton(
                    onTap: (){},
                  imagePath: 'lib/asset/icons8-facebook-50.png',),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () => onTapToRegister(context),
                    child: Text(
                      'Register',
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
