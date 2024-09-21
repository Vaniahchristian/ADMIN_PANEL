import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'display_menu.dart';
import 'menupage.dart';

// Your web Firebase configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBB6Jlkf1YZSv_YglI_iX6bl73TJuKAoR0",
  authDomain: "littlecafe-2554c.firebaseapp.com",
  projectId: "littlecafe-2554c",
  storageBucket: "littlecafe-2554c.appspot.com",
  messagingSenderId: "140771179995",
  appId: "1:140771179995:web:2227f773673c7639543bfe",
  measurementId: "G-K9X4211EF1",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web
  await Firebase.initializeApp(
    options: firebaseConfig,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const AdminMenuPage(),

        );
  }
}
