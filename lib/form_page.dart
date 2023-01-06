import 'dart:async';

import 'package:appmumbuca/account_page.dart';
import 'package:appmumbuca/home_page.dart';
import 'package:appmumbuca/packages/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final formsCollection = FirebaseFirestore.instance.collection('Formulários');

class FormPage extends StatefulWidget{
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPage();
}

class _FormPage extends State<FormPage> {
  TextEditingController newFormNameController = TextEditingController();

  final _tiposPerguntas = ["Múltipla Escolha","Caixas de Seleção","Escala Linear"];
  String? _tipoPerguntaEscolhido;

  obterTipoPergunta(cdTipoPergunta){
    var resposta="";
    switch (cdTipoPergunta){
      case "1": {
        resposta = "Múltipla Escolha";
      } break;
      case "2": {
        resposta = "Caixas de Seleção";
      } break;
      case "3": {
        resposta = "Escala Linear";
      } break;
    }
    return resposta;
  }
  obterOpcoes(DocumentSnapshot document){
    var cdTipoPergunta = document['CD_tipo_pergunta'];
    switch (cdTipoPergunta){
      case "1": {
        return StreamBuilder(
          stream: document.reference.collection('opcoes_escolha').snapshots(),
          builder:  (context, snapshot){
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((optionSnapshot) {
                return Row(
                    children: [
                      Text(optionSnapshot['Nm_escolha'], style: TextStyle(fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),

                    ]
                );
              }).toList() ,
            );
          },
        );
      }
      case "2": {
        return StreamBuilder(
          stream: document.reference.collection('opcoes_selecao').snapshots(),
          builder:  (context, snapshot){
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((optionSnapshot) {
                return Row(
                    children: [
                      Text(optionSnapshot['Nm_selecao'], style: TextStyle(fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),

                    ]
                );
              }).toList() ,
            );
          },
        );
      }
      case "3": {
        return Container();
      } break;
    }

  }
  changeFormName(newFormName){
    Forms_collection.doc(DefaultFirebaseOptions.documento).update({'Nome_Formulário' : newFormName});
    // DefaultFirebaseOptions.DATA['Nome_Formulário'] = newFormName;
  }
  getForms(){
    Forms_collection.doc(DefaultFirebaseOptions.documento).get().then((DocumentSnapshot doc) {
      DefaultFirebaseOptions.DATA = doc.data() as Map<String, dynamic>;
    });
  }

  addPergunta(){
    // print(DefaultFirebaseOptions.documento);
  }
  @override
  void initState(){
    super.initState();
    _tipoPerguntaEscolhido = _tiposPerguntas[0];
    Timer(const Duration(microseconds: 300), () => setState(() {}));
    getForms();
  }
  Widget build(BuildContext context) {
    Timer(const Duration(microseconds: 100), () => setState(() {}));
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        shape: BoxShape.rectangle,
                        color: Color(0xB1B71717),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: MediaQuery.of(context).size.height / 8,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(fontSize: 22, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                            controller: newFormNameController,
                            decoration: const InputDecoration(
                              labelText: 'Editar nome do formulário:',
                              hintText: 'Insira aqui um novo nome',
                              labelStyle: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                              hintStyle: TextStyle(color: Colors.black45,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe um novo nome válido.';
                              }
                              return null;
                            },
                          ),
                          Center(
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Color(0xB1B71717)),
                              ),
                              onPressed: () {
                                changeFormName(newFormNameController.text);
                              },
                              child: Text("Aplicar", textScaleFactor: 1.5, style: TextStyle(color: Colors.black,fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),),

                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("Adicionar Pergunta", textScaleFactor: 1.5, style: TextStyle(color: Colors.black,fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text("Tipo: ", textScaleFactor: 1.5, style: TextStyle(color: Colors.black,fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),
                            DropdownButton(items:_tiposPerguntas.map((item){
                              return DropdownMenuItem(value: item,child: Text(item),);
                            }).toList(),
                              value: _tipoPerguntaEscolhido,
                              onChanged:(val) {
                                setState(() {
                                  _tipoPerguntaEscolhido = val as String;

                                });
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            var colecaoPerguntas = FirebaseFirestore.instance.collection("Formulários").doc(DefaultFirebaseOptions.documento).collection("Perguntas");
                            var doc2 = colecaoPerguntas.doc();

                            String tipoPerguntaInteiro = '';
                            switch (_tipoPerguntaEscolhido){
                              case "Múltipla Escolha": {
                                tipoPerguntaInteiro = '1';
                                doc2.collection("opcoes_escolha").doc().set({'CD_escolha': '1' , 'Nm_escolha' : 'Exemplo de caixa de escolha.'});
                              } break;
                              case "Caixas de Seleção": {
                                tipoPerguntaInteiro = '2';
                                doc2.collection("opcoes_selecao").doc().set({'CD_selecao' : '1' , 'Nm_escolha' : 'Exemplo de caixa de seleção.' });;
                              } break;
                              case "Escala Linear": {
                                tipoPerguntaInteiro = '3';
                              } break;
                            }
                            doc2.set({"Nm_Enunciado": "Nova Pergunta", "CD_tipo_pergunta": tipoPerguntaInteiro});
                          },
                          color: Colors.white,
                          iconSize: 100,
                          icon: Icon(Icons.add_circle_rounded),
                        ),
                      ],
                    ),

                  ],
                ),

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
                            height: MediaQuery.of(context).size.height / 6,
                            child: Column(
                                children: [
                                  Text(document['Nm_Enunciado'], style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                                  Text("Tipo de Pergunta: " + obterTipoPergunta(document['CD_tipo_pergunta']) , style: TextStyle(fontSize: 30, fontFamily: 'Montserrat', fontWeight: FontWeight.normal)),
                                  Container(
                                    // Iterar sobre caixas de seleção.
                                    child: obterOpcoes(document),
                                  ),
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
