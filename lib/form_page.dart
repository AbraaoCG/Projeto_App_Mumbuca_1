import 'dart:async';

import 'package:appmumbuca/account_page.dart';
import 'package:appmumbuca/home_page.dart';
import 'package:appmumbuca/packages/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
final Forms_collection = FirebaseFirestore.instance.collection('Formulários');
class FormPage extends StatefulWidget{
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPage();
}

class _FormPage extends State<FormPage> {

  getForms(){
    Forms_collection.doc(DefaultFirebaseOptions.documento).get().then((DocumentSnapshot Doc) {
      DefaultFirebaseOptions.DATA = Doc.data() as Map<String, dynamic>;
    });
  }
  @override
  void initState(){
    super.initState();
    Timer(Duration(microseconds: 100), () => setState(() {}));
    getForms();
  }
  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 100), () => setState(() {}));
    getForms();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          backgroundColor: Color(0XFFB71717),
          toolbarHeight: 100,
          leading: IconButton(onPressed: (){
        Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            );}, icon: Icon(Icons.arrow_back)),
      title: Text(DefaultFirebaseOptions.DATA["Nome_Formulário"], textAlign: TextAlign.center, textScaleFactor: 1.7), 
          actions:
          <Widget>[
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () { // Abrir Tela de conta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.settings),
              onPressed: () { // código para abrir tela de configurações
              },
            ),
          ]
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0XFFB71717),
        child: Text("Data de Criação: " + DefaultFirebaseOptions.DATA["Data_Criação"], style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
      ),


    );

  }
}
