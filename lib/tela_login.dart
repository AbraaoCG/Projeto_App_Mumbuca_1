// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:appmumbuca/reset_password_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
      color: const Color(0xffb71717),
      child: ListView(children: <Widget>[
        SizedBox(
          width: 128,
          height: 128,
          child: Image.asset("assets/logo_login.png"),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          // autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Usuário",
            labelStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          // autofocus: true,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          style: TextStyle(
              fontSize: 20,
              color: Colors.white),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 40,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text(
              "ENTRAR",
              textAlign: TextAlign.right,
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                minimumSize: Size(327, 50),
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: const BorderSide(width: 1.0, color: Colors.white),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ))),
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordPage(),
                ),
              );*\
             */
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 40,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text(
              "ESQUECI MINHA SENHA",
              textAlign: TextAlign.right,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(327, 50),
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: const BorderSide(width: 1.0, color: Colors.white),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ))),
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordPage(),
                ),
              );*\
             */
          ),
        ),
      ]),
    ));
  }
}
