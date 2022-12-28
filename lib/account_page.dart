// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/login_page.dart';


class AccountPage extends StatefulWidget{
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {

  logout() async {
    try {
      await context.read<AuthService>().logout().then((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: OutlinedButton(
              onPressed: () => logout(),
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
