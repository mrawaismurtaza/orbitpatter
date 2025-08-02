import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orbitpatter/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
}
