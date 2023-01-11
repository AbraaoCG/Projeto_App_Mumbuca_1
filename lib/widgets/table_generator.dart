// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
// import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row,Column;

final Forms_collection = FirebaseFirestore.instance.collection('Formulários');
final colecaoUsuarios = FirebaseFirestore.instance.collection('testeusuarios');

class TableGenerator extends StatefulWidget {
  const TableGenerator({Key? key}) : super(key: key);

  @override
  State<TableGenerator> createState() => _TableGenerator();
}


class _TableGenerator extends State<TableGenerator> {


  Future<String> getUserName() async{
      var usuario = FirebaseAuth.instance.currentUser?.email;
// Create the query
      Query query =
      colecaoUsuarios.where('email', isEqualTo: '$usuario');
// Get the query snapshot
      QuerySnapshot snapshot = await query.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      // Retrieve the data from the document
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['nome']);
    }
    return 'SemID';
  }

  Future<String> generateCsv(input,DocumentSnapshot document) async {

    List<List<dynamic>?>? data = input;

    String csvData = ListToCsvConverter().convert(data);
    csvData = csvData.replaceAll("\"\"\"", "\"\"");
    csvData = csvData.replaceAll(", ", ",");

    print(csvData);

    final user = await getUserName();

    final String? directory = (await getExternalStorageDirectory())?.path;
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download'); //! THIS WORKS for android only !!!!!!

    var day = "${DateTime.now().day}" ; if (day.length != 2) {day = '0$day';}
    var month = "${DateTime.now().month}" ; if (month.length != 2) {month = '0$month';}

    final date = "$day$month${DateTime.now().year}";
    final fileName = "${user}_${date}_${document['Nome_Formulário'].replaceAll(" ","_")}"; // Salva Arquivo no formato usuario_data_nomeformulário
    final path2 = "${generalDownloadDir.path}/$fileName.csv";

    final File file = File(path2);
    await file.writeAsString(csvData, encoding: utf8);

    return path2;
  }

  Future<String> buildData(DocumentSnapshot document) async {
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

    Future<String> csvPath = generateCsv(newList,document);

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
                        Future<String> csvPathFuture = buildData(document);
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
                          LayoutBuilder(builder: (context, constraint) {
                            return new Icon(Icons.download, size: constraint.biggest.height);
                          }),
                        ],
                      ),
                    );
                  },
            );
          }),
    );
  }
}
