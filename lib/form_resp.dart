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
  var enderecos = [];
  var respostas = [];
  var value = 0;
  var quest = [];
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
    Timer(Duration(microseconds: 500), () => setState(() {}));
    getForms();
  }

  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 500), () => setState(() {}));
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
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
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
                        child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                          children: [
                            Text(document['Nm_Enunciado'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                            Text("Tipo de Pergunta: " +document['CD_tipo_pergunta'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),
                            Offstage(
                            offstage: document['CD_tipo_pergunta'] != '1',
                              child: StreamBuilder(
                                stream: Forms_collection.doc(DefaultFirebaseOptions.documento).collection("Perguntas").doc(document.id).collection('opcoes_escolha').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshota){
                                  var icon = null;
                                  if (!snapshota.hasData){
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }else{
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: ListView(
                                          shrinkWrap: true,
                                          clipBehavior: Clip.hardEdge,
                                          physics: ClampingScrollPhysics(),
                                          children: snapshota.data!.docs.map((document2){
                                            if(!quest.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                              value += 1;
                                              quest.add(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                            }else{

                                            }
                                            if (respostas.contains(document2.id)) {
                                              icon = Icon(Icons.check_circle);
                                            } else{
                                              icon = Icon(Icons.check_circle_outline_outlined);
                                            }
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              //child: Container(
                                              //  width: MediaQuery.of(context).size.width / 1.2,
                                             //   height: MediaQuery.of(context).size.height / 6,
                                                child: Row(
                                                  children: [
                                                    Text(document2['Nm_escolha'], textScaleFactor: 2,),
                                                    IconButton(onPressed: (){
                                                      if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                                        var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                                        enderecos.removeAt(local);
                                                        respostas.removeAt(local);
                                                      }else {
                                                        enderecos.add(
                                                            formsCollection.doc(
                                                                DefaultFirebaseOptions
                                                                    .documento)
                                                                .collection(
                                                                'Perguntas')
                                                                .doc(
                                                                document.id)
                                                                .collection(
                                                                'Respostas'));
                                                        respostas.add(
                                                            document2.id);
                                                      }
                                                      },
                                                        icon: icon,style: IconButton.styleFrom(
                                                        focusColor: Colors.red,
                                                        highlightColor: Colors.blue,
                                                          foregroundColor: Colors.black,
                                                    ))
                                                  ],
                                                ),
                                             // ),
                                              );
                                          },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  );}
                                }
                              ),
                            ),
                            Offstage(
                              offstage: document['CD_tipo_pergunta'] != '2',
                              child: StreamBuilder(
                                  stream: Forms_collection.doc(DefaultFirebaseOptions.documento).collection("Perguntas").doc(document.id).collection('opcoes_selecao').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshota){
                                    var icon = null;
                                    if (!snapshota.hasData){
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }else{
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: ListView(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              children: snapshota.data!.docs.map((document2){
                                                if(!quest.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                                  value += 1;
                                                  quest.add(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                                }else{

                                                }
                                                var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                                if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local].contains(document2.id)) {
                                                  icon = Icon(Icons.check_circle);
                                                } else{
                                                  icon = Icon(Icons.check_circle_outline_outlined);
                                                }
                                                return Align(
                                                  alignment: Alignment.topLeft,
                                                  //child: Container(
                                                  //  width: MediaQuery.of(context).size.width / 1.2,
                                                  //   height: MediaQuery.of(context).size.height / 6,
                                                  child: Row(
                                                    children: [
                                                      Text(document2['Nm_selecao'], textScaleFactor: 2,),
                                                      IconButton(onPressed: (){
                                                        if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                                          var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                                          if (respostas[local].contains(document2.id)){
                                                            respostas[local].remove(document2.id);
                                                          }else{
                                                            respostas[local].add(document2.id);
                                                          }
                                                        }else {
                                                          enderecos.add(
                                                              formsCollection.doc(
                                                                  DefaultFirebaseOptions
                                                                      .documento)
                                                                  .collection(
                                                                  'Perguntas')
                                                                  .doc(
                                                                  document.id)
                                                                  .collection(
                                                                  'Respostas'));
                                                          respostas.add(
                                                              [document2.id]);
                                                        }
                                                      },
                                                          icon: icon,style: IconButton.styleFrom(
                                                            focusColor: Colors.red,
                                                            highlightColor: Colors.blue,
                                                            foregroundColor: Colors.black,
                                                          ))
                                                    ],
                                                  ),
                                                  // ),
                                                );
                                              },
                                              ).toList(),
                                            ),
                                          ),
                                        ],
                                      );}
                                  }
                              ),
                            ),
                            Offstage(
                              offstage: document['CD_tipo_pergunta'] != '3',
                              child: Builder(builder: (context){
                                if(!quest.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                  value += 1;
                                  quest.add(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                }else{

                                }
                                var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                double icon1 = 0;
                                double icon2 = 0;
                                double icon3 = 0;
                                double icon4 = 0;
                                double icon5 = 0;
                                if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local] == '1'){
                                  icon1 = 20;
                                  icon2 = 0;
                                  icon3 = 0;
                                  icon4 = 0;
                                  icon5 = 0;
                                }
                                else if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local] == '2'){
                                  icon1 = 0;
                                  icon2 = 20;
                                  icon3 = 0;
                                  icon4 = 0;
                                  icon5 = 0;
                                }
                                else if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local] == '3'){
                                  icon1 = 0;
                                  icon2 = 0;
                                  icon3 = 20;
                                  icon4 = 0;
                                  icon5 = 0;
                                }
                                else if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local] == '4'){
                                  icon1 = 0;
                                  icon2 = 0;
                                  icon3 = 0;
                                  icon4 = 20;
                                  icon5 = 0;
                                }
                                else if (enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas')) && respostas[local] == '5'){
                                  icon1 = 0;
                                  icon2 = 0;
                                  icon3 = 0;
                                  icon4 = 0;
                                  icon5 = 20;
                                } else{
                                  icon1 = 0;
                                  icon2 = 0;
                                  icon3 = 0;
                                  icon4 = 0;
                                  icon5 = 0;
                                }
                                return Builder(builder: (context){return Row(
                                children: [
                                  IconButton(onPressed: (){
                                    if(enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                      var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                      enderecos.removeAt(local);
                                      respostas.removeAt(local);
                                    } else {
                                      enderecos.add(formsCollection.doc(
                                          DefaultFirebaseOptions.documento)
                                          .collection('Perguntas').doc(
                                          document.id)
                                          .collection('Respostas'));
                                      respostas.add('1');
                                    }
                                    }, icon: Image.asset('assets/Escala_Linear_Ruim.png'), iconSize: 75 + icon1,),
                                  IconButton(onPressed: (){
                                    if(enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                      var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                      enderecos.removeAt(local);
                                      respostas.removeAt(local);
                                    } else {
                                      enderecos.add(formsCollection.doc(
                                          DefaultFirebaseOptions.documento)
                                          .collection('Perguntas').doc(
                                          document.id)
                                          .collection('Respostas'));
                                      respostas.add('2');
                                    }
                                    }, icon: Image.asset('assets/Escala_Linear_Quase_Ruim.png'), iconSize: 75 + icon2,),
                                  IconButton(onPressed: (){
                                    if(enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                      var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                      enderecos.removeAt(local);
                                      respostas.removeAt(local);
                                    } else {
                                      enderecos.add(formsCollection.doc(
                                          DefaultFirebaseOptions.documento)
                                          .collection('Perguntas').doc(
                                          document.id)
                                          .collection('Respostas'));
                                      respostas.add('3');
                                    }
                                    }, icon: Image.asset('assets/Escala_Linear_Medio.png'), iconSize: 75 + icon3,),
                                  IconButton(onPressed: (){
                                    if(enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                      var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                      enderecos.removeAt(local);
                                      respostas.removeAt(local);
                                    } else {
                                      enderecos.add(formsCollection.doc(
                                          DefaultFirebaseOptions.documento)
                                          .collection('Perguntas').doc(
                                          document.id)
                                          .collection('Respostas'));
                                      respostas.add('4');
                                    }
                                    }, icon: Image.asset('assets/Escala_Linear_Quase_Bom.png'), iconSize: 75 + icon4,),
                                  IconButton(onPressed: (){
                                    if(enderecos.contains(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'))){
                                      var local = enderecos.indexOf(formsCollection.doc(DefaultFirebaseOptions.documento).collection('Perguntas').doc(document.id).collection('Respostas'));
                                      enderecos.removeAt(local);
                                      respostas.removeAt(local);
                                    } else {
                                      enderecos.add(formsCollection.doc(
                                          DefaultFirebaseOptions.documento)
                                          .collection('Perguntas').doc(
                                          document.id)
                                          .collection('Respostas'));
                                      respostas.add('5');
                                    }
                                    }, icon: Image.asset('assets/Escala_Linear_Bom.png'), iconSize: 75 + icon5,),
                                ],
                              );});})
                            )
                          ]
                        )
                      ),),
                    );
                  }).toList(),
                ),
              ),
            ],
          );

          }

        ),
      floatingActionButton: IconButton(
          onPressed: (){
            if(respostas.length == value) {
              for (int i = 0; i != respostas.length; i++) {
                print(respostas.length);
                print(i);
                var enderec = enderecos[i];
                print(enderec.runtimeType);
                enderec.add({'CD_resposta': respostas[i]});
                //formsCollection.doc(enderec[1]).collection(enderec[2]).doc(enderec[3]).collection(enderec[4]).add({'CD_resposta' : respostas[i]});
              }
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enviado!')));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Responda todas as questões!')));
            }},
          icon: Icon(Icons.check_circle_sharp, color: Colors.red,),
          iconSize: 75,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0XFFB71717),
        child: Text("Data de Criação: " + DefaultFirebaseOptions.DATA["Data_Criação"], style: TextStyle(color: Colors.white), textScaleFactor: 1.5),
      ),
    );
  }
}