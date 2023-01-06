import 'dart:async';

import 'package:appmumbuca/account_page.dart';
import 'package:appmumbuca/home_page.dart';
import 'package:appmumbuca/packages/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final formsCollection = FirebaseFirestore.instance.collection('Formulários');

class FormResp extends StatefulWidget{
  const FormResp({Key? key}) : super(key: key);

  @override
  State<FormResp> createState() => _FormResp();
}

class _FormResp extends State<FormResp> {

  changeFormName(newFormName) {
    print(newFormName);
    Forms_collection.doc(DefaultFirebaseOptions.documento).update(
        {'Nome_Formulário': newFormName});
    // DefaultFirebaseOptions.DATA['Nome_Formulário'] = newFormName;
  }

  getForms() {
    Forms_collection.doc(DefaultFirebaseOptions.documento).get().then((
        DocumentSnapshot doc) {
      DefaultFirebaseOptions.DATA = doc.data() as Map<String, dynamic>;
    });
  }

  addPergunta() {
    // print(DefaultFirebaseOptions.documento);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 300), () => setState(() {}));
    getForms();
  }

  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 100), () => setState(() {}));
    getForms();
    return Scaffold(
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
        body: StreamBuilder(
          stream: Forms_collection.doc(DefaultFirebaseOptions.documento).collection("Perguntas").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((document){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                          shape: BoxShape.rectangle,
                          color: Color(0xB1B71717),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Column(
                          children: [
                            Text(document['Nm_Enunciado'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                            Text("Tipo de Pergunta: " +document['CD_tipo_pergunta'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),
                            Offstage(
                            offstage: document['CD_tipo_pergunta'] != '1',
                              child: StreamBuilder(
                                stream: Forms_collection.doc(DefaultFirebaseOptions.documento).collection("Perguntas").doc(document.id).collection('opcoes_escolha').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshota){
                                  if (!snapshota.hasData){
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }else{
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView(
                                          children: snapshota.data!.docs.map((document2){
                                            return Center(
                                              child: Text(document2['Nm_escolha']),
                                              );
                                          },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  );}
                                }
                              ),
                            )
                          ]
                        )
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );

          }

        ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0XFFB71717),
        child: Text("Data de Criação: " + DefaultFirebaseOptions.DATA["Data_Criação"], style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
      ),
    );
  }
}