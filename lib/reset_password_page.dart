// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        backgroundColor: const Color(0xffb71717),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        color: Colors.white,
        child: ListView(children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset("assets/reset-password-icon.png"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Esqueceu sua senha?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Por favor, insira o e-mail associado à sua conta.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "E-mail",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text(
                "ENVIAR",
                textAlign: TextAlign.right,
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(327, 50),
                  backgroundColor: Color(0xffb71717),
                  elevation: 0,
                  side: const BorderSide(width: 1.0, color: Colors.white),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ))),
            ),
          ),
        ]),
      ),
    );
  }
}
