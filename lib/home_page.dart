// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
// import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/account_page.dart';
import 'package:appmumbuca/login_page.dart';
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
    final Form_List = [];
    Forms_collection.get().then((QuerySnapshot snapshot) =>
    {
      snapshot.docs.forEach((DocumentSnapshot doc) {
      })
    });
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
              onPressed: () {
                // Abrir Tela de conta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.settings),
              onPressed: () {
                // código para abrir tela de configurações
              },
            ),
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateUserPage(),
                            ),
                          );
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
                        onTap: () {},
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
                        height: MediaQuery.of(context).size.height / 6,
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
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection("Formulários").doc(document.id).delete();
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
                                          onPressed: () {
                                            DefaultFirebaseOptions.documento = document.id;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const FormPage()),
                                            );
                                          },
                                          child: Text("Editar Formulário", textScaleFactor: 1.5),

                                        ),
                                      ),
                                    )
                                  ]
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
        return Container(
          //color: Colors.redAccent,
          child: IconButton(
            onPressed: () {
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


class _Survey extends StatelessWidget {
  const _Survey({required this.surveyName, required this.surveyCreationDate});
  final String surveyName;
  final String surveyCreationDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          "",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ));
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;

  const GradientAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: const [Colors.red, Colors.blue],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
