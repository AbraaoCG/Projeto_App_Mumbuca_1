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
import 'package:csv/csv.dart';

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
    var value;
    var docResposta;
    Set<String> enunciados = {};

    List<dynamic> linhasCSV = [];

    //print(document.reference); // Path do documento

    // Acessando Perguntas
    CollectionReference collPerguntas = document.reference.collection('Perguntas');

    // Acessando documentos de Perguntas
    QuerySnapshot snapshot = await collPerguntas.get();

    int len_collPerguntas = snapshot.size;

    print("numm perguntas: " );
    print(len_collPerguntas);

    for (int j = 0; j < len_collPerguntas-1; j++) { // qtd perguntas


      // Acessa j-ésimo documento de pergunta.
      var doc = snapshot.docs[j];
      var enunciado = doc['Nm_Enunciado'];
      enunciados.add(enunciado);

      // Accessa coleção 'Respostas'.
      CollectionReference collRespostas = doc.reference.collection('Respostas');
      // Get 'Respostas' documents into snapshotResposta QuerySnapshot.
      QuerySnapshot snapshotRespostas = await collRespostas.get();
      int len_collRES = snapshotRespostas.size;

      print("numm respostas: " );
      print(len_collRES);

      for (int i = 0; i < len_collRES; i++) { // qtd respostas

        List<dynamic> respostas = [];
        docResposta = snapshotRespostas.docs[i];
        value = docResposta['CD_resposta'];
        print("tipo pergunta :" + doc['CD_tipo_pergunta']);
        switch (doc['CD_tipo_pergunta']) {
          case '1': {
            CollectionReference collOpcoes_escolha = doc.reference.collection('opcoes_escolha');
            QuerySnapshot snapshotOpcoes_escolha = await collOpcoes_escolha.get();

            try {
              snapshotOpcoes_escolha.docs.forEach((docOpcoes_escolha) {
                //print('docOpcoes_selecao.data() : ${docOpcoes_escolha.data()}');
                //print('docOpcoes_selecao.id() : ${docOpcoes_escolha.id}');
                //print('value: $value');

                Map<String, dynamic> mapOpcoes_escolha = docOpcoes_escolha
                    .data() as Map<String, dynamic>;
                if (mapOpcoes_escolha.containsKey('Nm_escolha') && docOpcoes_escolha.id == value) {
                  value = '"'+mapOpcoes_escolha['Nm_escolha']+'"';
                }
              });

            } on Exception catch(_) {
              // Do nothing, just continue to the next iteration
            }

          } break;
          case '2': {

            CollectionReference collOpcoes_selecao = doc.reference.collection('opcoes_selecao');
            QuerySnapshot snapshotOpcoes_selecao = await collOpcoes_selecao.get();

            try {
              snapshotOpcoes_selecao.docs.forEach((docOpcoes_selecao) {
                //print('docOpcoes_selecao.data() : ${docOpcoes_selecao.data()}');
                //print('docOpcoes_selecao.id() : ${docOpcoes_selecao.id}');
                //print('value: $value');

                Map<String, dynamic> mapOpcoes_selecao = docOpcoes_selecao
                    .data() as Map<String, dynamic>;
                print(docOpcoes_selecao['Nm_selecao']);
                print("value: " + value);
                if (mapOpcoes_selecao.containsKey('Nm_selecao')) {
                  for (int k = 0; k < value.length; k++) {
                    if (docOpcoes_selecao.id == value[k]) {
                      value[k] = '"'+mapOpcoes_selecao['Nm_selecao']+'"';
                    }
                  }
                }
              });

            } on Exception catch(_) {
              // Do nothing, just continue to the next iteration
            }

          } break;
          case '3': {
            // Define the mapping from numbers to text
            Map<int, String> numberToText = {
              1: 'Péssimo',
              2: 'Ruim',
              3: 'Normal',
              4: 'Bom',
              5: 'Excelente'
            };
          } break;
        }




        // Define a regular expression that matches any single digit
        // RegExp numberRegExp = RegExp(r'\d');

        // Check if the string matches the regular expression
        //if (value.length == 1 && numberRegExp.hasMatch(value)) {
          //// If the string contains a single digit, apply the mapping
        //  value = '"'+'${numberToText[int.parse(value)]}'+'"';
        //}

        respostas.add(value);

        respostasEnunciados.add(respostas);

      }

      linhasCSV.add(respostasEnunciados);
      print('adicionou $respostasEnunciados em linhasCSV');
      print('');
      respostasEnunciados = [];
      print('linhasCSV: $linhasCSV');
      print('');

          }

    listaEnunciados = enunciados.toList();

    print("result");
    print(listaEnunciados);
    print('');
    print(linhasCSV);
    print('');



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
