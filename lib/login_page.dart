// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

// import 'package:appmumbuca/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  String titulo = "Tela de Login";

  @override
  void initState() {
    super.initState();
  }

  login() async {
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    // Método posicionado aqui, porém na verdade deverá ser
    try {
      // usado em outra página.
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71717),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 210,
                height: 210,
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset("assets/logo_login.png"),
                )
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 34, top: 16, left: 30, right: 30),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: email,
                        style: TextStyle(fontSize: 35),
                        decoration: InputDecoration(
                          labelText: "Email",
                          icon: Icon(Icons.person),
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe seu email para entrar.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 34, top: 16, left: 30, right: 30),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: senha,
                        obscureText: true,
                        style: TextStyle(fontSize: 35),
                        decoration: InputDecoration(
                          labelText: "Senha",
                          icon: Icon(Icons.key),
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe sua senha para login.';
                          } else if (value.length < 6) {
                            return 'Sua senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(24.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(//<-- SEE HERE
                            ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Entrar",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ], // Children
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Procedimento necessário',
                                  style: TextStyle(fontSize: 40),
                                    textAlign: TextAlign.center),
                                content: Text(
                                    'Por favor, procure um administrador na sede do banco para recuperar suas credenciais.',
                                  style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.start),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],

                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Esqueci minha senha",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ], // Children
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/** teste **/