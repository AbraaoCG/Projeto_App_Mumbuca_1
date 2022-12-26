// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

import 'package:appmumbuca/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/my_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Wait Firebase
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService() ),
        ],
        child: const MyApp()
      ),
  );
}
