// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:path_provider/path_provider.dart';

final Forms_collection = FirebaseFirestore.instance.collection('Formulários');

class TableGenerator extends StatefulWidget {
  const TableGenerator({Key? key}) : super(key: key);

  @override
  State<TableGenerator> createState() => _TableGenerator();
}


class _TableGenerator extends State<TableGenerator> {



  Future<String> generateCsv(input) async {

    List<List<dynamic>?>? data = input;

    String csvData = ListToCsvConverter().convert(data);
    csvData = csvData.replaceAll("\"\"\"", "\"\"");
    csvData = csvData.replaceAll(", ", ",");

    final String? directory = (await getExternalStorageDirectory())?.path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    final File file = File(path);
    await file.writeAsString(csvData);

    return path;
  }

  Future<String> buildCsv(DocumentSnapshot document) async {
    List<dynamic> listaEnunciados = [];
    List<dynamic> respostasEnunciados = [];
    var value;
    var docResposta;
    List<dynamic> enunciados = [];

    List<dynamic> linhasCSV = [];
    // Acessando Perguntas
    CollectionReference collPerguntas = document.reference.collection('Perguntas');
    // Acessando documentos de Perguntas
    QuerySnapshot snapshot = await collPerguntas.get();
    int len_collPerguntas = snapshot.size;

    for (int j = 0; j < len_collPerguntas; j++) { // qtd perguntas

      // Acessa j-ésimo documento de pergunta.
      var doc = snapshot.docs[j];
      var enunciado = doc['Nm_Enunciado'];
      enunciados.add(enunciado);

      // Accessa coleção 'Respostas'.
      CollectionReference collRespostas = doc.reference.collection('Respostas');
      // Get 'Respostas' documents into snapshotResposta QuerySnapshot.
      QuerySnapshot snapshotRespostas = await collRespostas.get();

      int len_collRES = snapshotRespostas.size;

      for (int i = 0; i < len_collRES; i++) { // qtd respostas

        List<dynamic> respostas = [];
        docResposta = snapshotRespostas.docs[i]; // acessa os documentos de Respostas
        value = docResposta['CD_resposta'];
        switch (doc['CD_tipo_pergunta']) {
          case '1': {

            CollectionReference collOpcoes_escolha = doc.reference.collection('opcoes_escolha');
            QuerySnapshot snapshotOpcoes_escolha = await collOpcoes_escolha.get();

            try {
              snapshotOpcoes_escolha.docs.forEach((docOpcoes_escolha) {
                Map<String, dynamic> mapOpcoes_escolha = docOpcoes_escolha
                    .data() as Map<String, dynamic>;
                if (mapOpcoes_escolha.containsKey('Nm_escolha') && docOpcoes_escolha.id == value) {
                  value = mapOpcoes_escolha['Nm_escolha'];
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
                Map<String, dynamic> mapOpcoes_selecao = docOpcoes_selecao
                    .data() as Map<String, dynamic>;

                if (mapOpcoes_selecao.containsKey('Nm_selecao')) {
                  for (int k = 0; k < value.length; k++) {
                    if (docOpcoes_selecao.id == value[k]) {
                      value[k] = mapOpcoes_selecao['Nm_selecao'];
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
            Map<String, String> numberToText = {
              '1': 'Péssimo',
              '2': 'Ruim',
              '3': 'Normal',
              '4': 'Bom',
              '5': 'Excelente'
            };
            value = numberToText[value.toString()];
          }
          break;
        }

        respostas.add(value);
        dynamic removeBrackets(List<dynamic> list) {
          return list.join(',').replaceAll('[','').replaceAll(']','');
        }

        if (doc['CD_tipo_pergunta'] == '2'){ // Se for de seleçao, adiciono [] para ser identificado
          respostasEnunciados.add('${'[' + removeBrackets(respostas)}]');
        } else {
          respostasEnunciados.add('${removeBrackets(respostas)}');
        }
      }
      linhasCSV.add(respostasEnunciados);
      respostasEnunciados = [];
          }

    listaEnunciados = enunciados.toList();

    var listaRespostas = linhasCSV.transpose;
    List<List<dynamic>> newList = List.from(listaRespostas);
    newList.insert(0, listaEnunciados);

    Future<String> csvPath = generateCsv(newList);

    return csvPath;
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
                      onTap: () async {

                        String csvPath = "";
                        Future<String> csvPathFuture = buildCsv(document);
                        csvPath = await csvPathFuture;

                        if (csvPath != ""){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Tabela Csv Gerada!' ,
                                    style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                                content: Column(
                                  children: [
                                    Text(
                                      'A tabela para o formulário desejado foi gerada e está localizada em: ',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.normal),
                                    ),
                                    Divider(),
                                    Text(
                                      csvPath,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  FloatingActionButton(
                                      child: const Icon(Icons.check),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }),
                                ],
                              );
                            },
                          );
                        }

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
