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

final User_Collection = FirebaseFirestore.instance.collection('testeusuarios');

class UserEditor extends StatefulWidget {
  const UserEditor({Key? key}) : super(key: key);

  @override
  State<UserEditor> createState() => _UserEditor();
}

class _UserEditor extends State<UserEditor> {

  deleteUserAuth(DocumentSnapshot document) async {
    // FirebaseUser user = FirebaseAuth.

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
          actions: <Widget>[]),
      body: StreamBuilder(
          stream: User_Collection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1.5,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];

                String email = document['email'];
                List<String> partesEmail = email.split("@");
                String emailAntesArroba = partesEmail[0];
                String emailDepoisArroba = "@" + partesEmail[1];

                return ListTile(
                  title: Text(document['nome'],
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    children: [
                      Text(
                          "Email: ${emailAntesArroba.substring(0,1)}***$emailDepoisArroba" ,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal)
                      ),
                      Text(
                          "Nível de acesso: " + document['acesso'],
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal)
                      ),
                    ],
                  ),
                  onTap: () {
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmar exclusão'),
                                content: Text('Tem certeza que quer deletar o usuário abaixo? \n\n${document['nome']} \n\nATENÇÃO: Não será mais possível recuperá-lo após a exclusão.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('CANCELAR OPERAÇÃO'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Deletar'),
                                    onPressed: () async {
                                      await deleteUserAuth(document);
                                      await document.reference.delete();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                  IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          String novoNome = "";
                          String novoEmail = "";
                          String novoAcesso = "";
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                    title: const Text("Alterar Informações do Usuário" , style: TextStyle(color: Color(0xB1B71717),fontSize: 28, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                                    content:
                                    Column(
                                      children: [
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Editar nome do usuário:',
                                            hintText: 'Insira aqui um novo nome',
                                            labelStyle: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                            hintStyle: TextStyle(color: Colors.black45,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          ),
                                          style: const TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          autofocus: true,
                                          onChanged: (value){
                                            novoNome = value;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Editar email do usuário:',
                                            hintText: 'Insira aqui um novo email',
                                            labelStyle: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                            hintStyle: TextStyle(color: Colors.black45,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          ),
                                          style: const TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          autofocus: true,
                                          onChanged: (value){
                                            novoEmail = value;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Editar Acesso do usuário:',
                                            hintText: 'Insira aqui --> Usuário ou Administrador',
                                            labelStyle: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                            hintStyle: TextStyle(color: Colors.black45,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          ),
                                          style: const TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
                                          autofocus: true,
                                          onChanged: (value){
                                            novoAcesso = value;
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      CloseButton(onPressed: (){
                                        Navigator.pop(context);
                                      }),
                                      FloatingActionButton(
                                          child: const Icon(Icons.send),
                                          onPressed: (){
                                            if (novoNome == ""    ){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insira um novo nome válido" , style: TextStyle(color: Colors.white,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.bold))));
                                            } else if(novoEmail == ""){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insira um novo email válido" , style: TextStyle(color: Colors.white,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.bold))));
                                            }
                                            else if ( novoAcesso != "Administrador" && novoAcesso != "Usuário"){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insira um novo Acesso válido (Usuário ou Administrador)" , style: TextStyle(color: Colors.white,fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.bold))));
                                            }
                                            else{
                                              document.reference.update({ 'nome' : novoNome });
                                              document.reference.update({ 'email' : novoEmail });
                                              document.reference.update({ 'acesso' : novoAcesso });
                                              Navigator.pop(context);
                                            }
                                          }
                                      ),
                                    ]
                                );
                              }
                          );
                        },
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
