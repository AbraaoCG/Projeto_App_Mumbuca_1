// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
// import 'dart:html';
import 'package:appmumbuca/widgets/table_generator.dart';
import 'package:appmumbuca/widgets/user_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/login_page.dart';
import 'form_resp.dart';
import 'register_page.dart';
import 'package:appmumbuca/packages/firebase_options.dart';
import 'package:appmumbuca/form_page.dart';

final Forms_collection = FirebaseFirestore.instance.collection('Formulários');
final colecaoUsuarios = FirebaseFirestore.instance.collection('testeusuarios');

class HomePage extends StatefulWidget {
  final String? emailUsuario;
  const HomePage({Key? key, this.emailUsuario})
      : super(key: key); // Importando email do login_page

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  String _nomeUsuario = 'default';
  String _acessoUsuario = 'default';

  void dadosUsuario() async {
    var usuario = FirebaseAuth.instance.currentUser?.email;
// Create the query
    Query query =
    colecaoUsuarios.where('email', isEqualTo: '$usuario');
// Get the query snapshot
    QuerySnapshot snapshot = await query.get();

// Iterate through the documents in the snapshot
    for (DocumentSnapshot doc in snapshot.docs) {
      // Retrieve the data from the document
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        _nomeUsuario = (data['nome']);
        _acessoUsuario = (data['acesso']);
      });

    }
  }

  logout() async {
    try {
      await context.read<AuthService>().logout().then((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getLength(snapshot) {
    var length = 0;
    Forms_collection.get().then((value) =>
    {
      length = value.docs.length,
    });
    return length;
  }

  getForms() {
    Forms_collection.get().then((QuerySnapshot snapshot) =>
    {
      snapshot.docs.forEach((DocumentSnapshot doc) {
      })
    });
  }
  Future<bool> verifyRegisterFirestore() async {
    // Verifica-se se o usuário autenticado está na base de dados do firestore, se sim retorna true, senão false.
    var usuario = FirebaseAuth.instance.currentUser?.email;
    Query query = usersCollection.where('email', isEqualTo: '$usuario');
    QuerySnapshot querySnapshot = await query.get();

    return querySnapshot.docs.isNotEmpty;
  }
  noCredentialAlert(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Bloqueio de Segurança" , style: TextStyle(color: Color(0xB1B71717),fontSize: 28, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
            content: Text(
              "Sua credencial foi desabilitada por um dos administradores. Entre em contato para regularizar seu cadastro!",
              style: const TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
            ),
            actions: <Widget>[
              CloseButton(onPressed: (){
                Navigator.pop(context);
                logout();
              }),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    dadosUsuario();
    getForms();
    super.initState();

  }

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
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
          actions: <Widget>[
          ]),


      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(children: <Widget>[
          Container(
              height: 300,
              color: Color(0xFFB71717),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Transform.scale(
                      scale: 0.7,
                      child: Image.asset("assets/user.png"),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            _nomeUsuario,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71717)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _acessoUsuario,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  title: Text(
                    'Ver perfil',
                    style: TextStyle(fontSize: 30),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      child: Transform.scale(
                          scale: 2, child: Icon(Icons.account_circle)),
                    ),
                  ),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Deixar um feedback',
                    style: TextStyle(fontSize: 30),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      child: Transform.scale(
                          scale: 2, child: Icon(Icons.feedback)),
                    ),
                  ),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Sobre o aplicativo',
                    style: TextStyle(fontSize: 30),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      child: Transform.scale(scale: 2, child: Icon(Icons.info)),
                    ),
                  ),
                  onTap: () {},
                ),
                Divider(),

                /** AQUI COMEÇAM AS FUNCIONALIDADES RESTRITAS A ADMINISTRADORES **/

                Offstage(
                  offstage: _acessoUsuario != 'Administrador', // 'redefinirNoCodigo'
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Cadastrar usuários',
                          style: TextStyle(fontSize: 30),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: Transform.scale(
                                scale: 2, child: Icon(Icons.add)),
                          ),
                        ),
                        onTap: () async {
                          if ( await verifyRegisterFirestore() ){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateUserPage(),
                              ),
                            );
                          } else {
                            noCredentialAlert();
                          }

                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Listar usuários cadastrados',
                          style: TextStyle(fontSize: 30),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: Transform.scale(
                                scale: 2, child: Icon(Icons.list)),
                          ),
                        ),
                        onTap: () async {
                          if (await verifyRegisterFirestore() ){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserEditor(),
                              ),
                            );
                          } else{
                            noCredentialAlert();
                          }
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Gerar tabela com respostas',
                          style: TextStyle(fontSize: 30),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: Transform.scale(
                                scale: 2, child: Icon(Icons.restore_page)),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TableGenerator(),
                            ),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),

                /** AQUI TERMINAM AS FUNCIONALIDADES RESTRITAS A ADMINISTRADORES **/

                ListTile(
                  title: Text(
                    'Deslogar do aplicativo',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71717)),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      child: Transform.scale(
                          scale: 2,
                          child: Icon(
                            Icons.logout,
                            color: Color(0xFFB71717),
                          )),
                    ),
                  ),
                  onTap: () {
                    logout();
                  },
                ),
                Divider(),
              ],

              // Fim adicionando sidebar,
            ),
          ),
        ]),
      ),

      body: StreamBuilder(

          stream: Forms_collection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                          shape: BoxShape.rectangle,
                          color: Color(0xFFB71717),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Column(
                          children: [
                            Text(document['Nome_Formulário'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                            Text("Data de Criação: " + document['Data_Criação'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal)),
                            Offstage(
                              offstage: _acessoUsuario != 'Administrador',
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (await verifyRegisterFirestore()){
                                              FirebaseFirestore.instance.collection("Formulários").doc(document.id).delete();
                                            }
                                            else{
                                              noCredentialAlert();
                                            }
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
                                          onPressed: () async {
                                            DefaultFirebaseOptions.documento = document.id;
                                            if (await verifyRegisterFirestore()){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const FormPage()),
                                              );
                                            } else{
                                              noCredentialAlert();
                                            }

                                          },
                                          child: Text("Editar Formulário", textScaleFactor: 1.5),

                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 300,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    DefaultFirebaseOptions.documento = document.id;
                                    if (await verifyRegisterFirestore()){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const FormResp()),
                                      );
                                    } else {
                                      noCredentialAlert();
                                    }
                                  },
                                  child: Text("Responder Formulário", textScaleFactor: 1.4),

                                ),
                              ),
                            ),
                          ]

                        )
                    ),

                );
              }).toList(),
            );
          }),

    floatingActionButton: StreamBuilder(
      stream: Forms_collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Offstage(
          offstage: _acessoUsuario != 'Administrador',
          child: IconButton(
            onPressed: () async {
              if (await verifyRegisterFirestore()){
                var data = {
                  "Nome_Formulário": "Novo Formulário",
                  "Data_Criação": DateTime.now().day.toString() +
                      "/" +
                      DateTime.now().month.toString() +
                      "/" +
                      DateTime.now().year.toString(),
                };
                var doc1 =
                FirebaseFirestore.instance.collection("Formulários").doc();
                doc1.set(data);
                var doc1id = doc1.id;
                var doc2 = FirebaseFirestore.instance
                    .collection("Formulários")
                    .doc(doc1id.toString())
                    .collection("Perguntas")
                    .doc();
                doc2.set({"Nm_Enunciado": "Nova Pergunta", "CD_tipo_pergunta": "1"});
              } else{
                noCredentialAlert();
              }
            },
            color: Colors.red,
            iconSize: 100,
            icon: Icon(Icons.add_circle_rounded),
          ),
        );
      },
    ),
    );
  }
}