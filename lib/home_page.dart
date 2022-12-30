// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

// import 'dart:html';
//import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/account_page.dart';

final Forms_collection = FirebaseFirestore.instance.collection('Formulários');

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {


    getLength(snapshot){
      var length = 0;
      Forms_collection.get().then((value) => {
        length = value.docs.length,
      });
      return length;
    }
    getForms(){
      final Form_List = [];
      Forms_collection.get().then((QuerySnapshot snapshot) => {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          print(doc['Nome_Formulário']);
        })
      });    }
  @override
  void initState(){
    getForms();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          backgroundColor: Color(0XFFB71717),
          toolbarHeight: 100,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/LogoMumbuca.png',
                  fit: BoxFit.contain,
                  height: 90,
                ),
                Text(
                  "Banco Mumbuca Pesquisas",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]
          ),
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
        stream: Forms_collection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
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
                    height: MediaQuery.of(context).size.height / 6,
                      child: Column(
                        children: [
                          Text(document['Nome_Formulário'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                          Text("Data de Criação: " +document['Data_Criação'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                             child: Container(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection("Formulários").doc(document.id).delete();
                                  },
                                  child: Text("Deletar Formulário", textScaleFactor: 1.4),

                                ),
                              ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              child: Container(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection("Formulários").doc(document.id).delete();
                                  },
                                  child: Text("Editar Formulário", textScaleFactor: 1.5),

                                ),
                              ),
                              )
                            ]
                          )


                      ]

                  )
                  ),
                );
            }).toList(),
          );
        }

    ),
      floatingActionButton: StreamBuilder(
          stream: Forms_collection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
            //color: Colors.redAccent,
           child: IconButton(
            onPressed: () {
              var data = {
                "Nome_Formulário": "Novo Formulário",
                "Data_Criação": DateTime
                    .now()
                    .day
                    .toString() + "/" + DateTime
                    .now()
                    .month
                    .toString() + "/" + DateTime
                    .now()
                    .year
                    .toString(),
              };
              var doc1 = FirebaseFirestore.instance.collection("Formulários").doc();
              doc1.set(data);
              var doc1id = doc1.id;
              print(doc1id);
              var doc2 = FirebaseFirestore.instance.collection("Formulários")
                      .doc(doc1id.toString())
                      .collection("Perguntas")
                      .doc();
              doc2.set({"Enunciado": "Novo Enunciado", "tipo_pergunta": "0"});
              var doc2id = doc2.id;
                //  var docid2 = snapshot.data!.docs.last.id;
                FirebaseFirestore.instance.collection("Formulários").doc(
                    doc1id.toString())
                    .collection("Perguntas").doc(doc2id.toString())
                    .collection(
                    "Respostas")
                    .add({"resposta_codigo": 0});
            },
            color: Colors.red,
            iconSize: 100,
            icon: Icon(Icons.add_circle_rounded),

          ),
        );
      }
    ),
    );
    }
}



class _Survey extends StatelessWidget {
  const _Survey({required this.surveyName, required this.surveyCreationDate});
  final String surveyName;
  final String surveyCreationDate;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Text(
            "",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      )
    );
  }

}
class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 50.0;


  const GradientAppBar(this.title, {super.key});


  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: const [Colors.red, Colors.blue],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

    );
  }
}
