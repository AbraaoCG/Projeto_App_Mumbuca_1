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

  CD_resposta_pesquisas(DocumentSnapshot document) async {
    List<dynamic> listaEnunciados = [];
    List<dynamic> respostasEnunciados = [];
    int i;
    int j;
    var value;

    List<dynamic> linhasCSV = [];

    //print(document.reference); // Path do documento

    // Acessando Perguntas
    CollectionReference collPerguntas = document.reference.collection('Perguntas');

    // Acessando documentos de Perguntas
    QuerySnapshot snapshot = await collPerguntas.get();

    var docResposta;

    int len_collPerguntas = snapshot.size;

    for (int j = 0; j < len_collPerguntas+1; j++) { // qtd perguntas

      for (int i = 0; i < len_collPerguntas; i++) { // qtd respostas
        // Get the i-th Perguntas document
        var doc = snapshot.docs[i];

        var enunciado = doc['Nm_Enunciado'];
        //print('');
        //print('Analisando resultado: $enunciado');

          if (listaEnunciados.contains(enunciado)) {
            //print('');
          } else {
            listaEnunciados.add(enunciado);
          }

            // Access 'Respostas' collection
            CollectionReference collRespostas = doc.reference.collection('Respostas');

            // Get 'Respostas' documents
            QuerySnapshot snapshotRespostas = await collRespostas.get();

            List<dynamic> respostas = [];

            try {
              docResposta = snapshotRespostas.docs[j];
            } on RangeError catch (_) {
              //print('não existe uma resposta aqui');
              continue;
            }

            value = docResposta['CD_resposta'];
            //print('value encontrado: $value');

        // tratar aqui os nomes

        // Access 'Respostas' collection
        CollectionReference collOpcoesSelecao = doc.reference.collection('opcoes_selecao');

        // Get 'Respostas' documents
        QuerySnapshot snapshotcollOpcoesSelecao = await collOpcoesSelecao.get();

        var docOpcoesSelecao = snapshotcollOpcoesSelecao.docs;

        for (var doc in docOpcoesSelecao) {
          // Get the ID of the current document
          var docId = doc.id;

          // Compare the ID to the variable
          if (value.contains(doc.id)) {
            value = doc['Nm_selecao'];
          }

        }

        respostas.add(value);

            respostasEnunciados.add(respostas);
            }

      linhasCSV.add(respostasEnunciados);
      //print('adicionou $respostasEnunciados em linhasCSV');
      respostasEnunciados = [];
      //print('linhasCSV: $linhasCSV');

          }

    // retornaria aqui se fosse exportar o CSV codificado
    //return linhasCSV;

    print(linhasCSV);
    //print(listaEnunciados);



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
