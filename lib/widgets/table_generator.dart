// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
// import 'dart:html';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appmumbuca/packages/firebase_options.dart';
import 'package:appmumbuca/form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final Forms_collection = FirebaseFirestore.instance.collection('Formulários');

class TableGenerator extends StatefulWidget {
  const TableGenerator({Key? key}) : super(key: key);

  @override
  State<TableGenerator> createState() => _TableGenerator();
}

class _TableGenerator extends State<TableGenerator> {

  void CD_resposta_pesquisas(DocumentSnapshot document) async {

    List listaEnunciados = [];
    List respostasEnunciados = [];

    //print(document.reference); // Path do documento

    // Acessando Perguntas
    CollectionReference colPerguntas = document.reference.collection('Perguntas');

    // Acessando documentos de Perguntas
    QuerySnapshot snapshot = await colPerguntas.get();

    // Iterando em Perguntas
    for (var doc in snapshot.docs) {
      var enunciado = doc['Nm_Enunciado'];
      listaEnunciados.add(enunciado);

      // Access 'Respostas' collection
      CollectionReference colRespostas = doc.reference.collection('Respostas');

      // Get 'Respostas' documents
      QuerySnapshot snapshotRespostas = await colRespostas.get();

      snapshotRespostas.docs.forEach((docResposta) {
        try {
          var value = docResposta['CD_resposta'];
          respostasEnunciados.add(value);
        } catch (e) {
          respostasEnunciados.add(-1);
        }

      });

    };

    print(listaEnunciados);
    print(respostasEnunciados);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFB71717),
          toolbarHeight: 100,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/LogoMumbuca.png',
              fit: BoxFit.contain,
              height: 90,
            ),
            Text(
              "Banco Mumbuca Pesquisas",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
          actions: <Widget>[
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () {},
            ),
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ]),
      body: StreamBuilder(
          stream: Forms_collection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(document['Nome_Formulário'],
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "Data de Criação: " + document['Data_Criação'],
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal)),
                      onTap: () {

                        CD_resposta_pesquisas(document);



                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  },
            );
          }),
    );
  }
}
