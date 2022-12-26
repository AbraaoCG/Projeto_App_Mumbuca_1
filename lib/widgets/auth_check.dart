// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

import 'package:appmumbuca/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/login_page.dart';
import 'package:appmumbuca/home_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AutoCheckState();
}

class _AutoCheckState extends State<AuthCheck>{

  @override
  Widget build(BuildContext context){
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const LoginPage();
    } else {
      return  const HomePage();
    }
  }

  loading() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          Text(
          'Carregando Tela Inicial',
          style: Theme.of(context).textTheme.titleLarge,
          ),
          CircularProgressIndicator(
          semanticsLabel: 'Circular progress indicator',
          ),
          ],
          ),
    )
    );
  }

}