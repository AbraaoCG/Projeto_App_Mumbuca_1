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

  /**generatecsv() async {
    List<List<String>> data = [
      ["No.", "Name", "Roll No."],
      ["1", randomAlpha(3), randomNumeric(3)],
      ["2", randomAlpha(3), randomNumeric(3)],
      ["3", randomAlpha(3), randomNumeric(3)]
    ];
    String csvData = ListTocsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadcsvDataScreen(path: path);
        },
      ),
    );
  } **/

  void CD_resposta_pesquisas(DocumentSnapshot document) async {
    List<dynamic> listaEnunciados = [];
    List<dynamic> respostasEnunciados = [];
    int i;
    int j;

    List<dynamic> linhasCSV = [];

    //print(document.reference); // Path do documento

    // Acessando Perguntas
    CollectionReference collPerguntas = document.reference.collection('Perguntas');

    // Acessando documentos de Perguntas
    QuerySnapshot snapshot = await collPerguntas.get();

    int len_collPerguntas = snapshot.size;

    for (int i = 0; i < len_collPerguntas; i++) {
      // Get the i-th Perguntas document
      var doc = snapshot.docs[i];

      var enunciado = doc['Nm_Enunciado'];
      print('');
      print('Analisando resultado: $enunciado');
      listaEnunciados.add("$enunciado");
      print('Lista de enunciados: $listaEnunciados');

      // Access 'Respostas' collection
      CollectionReference collRespostas = doc.reference.collection('Respostas');

      // Get 'Respostas' documents
      QuerySnapshot snapshotRespostas = await collRespostas.get();
      int len_collRespostas = snapshotRespostas.size;

      var docResposta = snapshotRespostas.docs[0];
      var value = docResposta['CD_resposta'];
      print('value encontrado: $value');
      respostasEnunciados.add(value);

    }


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
