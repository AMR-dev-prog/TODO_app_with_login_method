import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    getNotifcation();
  }

  Future<void> getNotifcation() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print("===========================================================");
        print("FCM Token: $token");
      } else {
        print("===========================================================");
        print("Failed to retrieve FCM Token.");
      }
    } catch (e) {
      print("Error retrieving FCM Token: $e");
    }
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission.");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission.");
    } else {
      print("User declined or has not granted permission.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
    );
  }
}
