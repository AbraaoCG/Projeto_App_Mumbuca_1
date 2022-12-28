// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/login_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: OutlinedButton(
            onPressed: () async {
              await context.read<AuthService>().logout();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black38

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
