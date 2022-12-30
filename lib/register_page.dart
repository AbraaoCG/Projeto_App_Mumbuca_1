// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

import 'package:appmumbuca/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool validateName(String name) {
  final RegExp nameExp = RegExp(r'^([a-zA-Zà-úÀ-Ú]|-|_|\s)+$');
  return name.length >= 1 && nameExp.hasMatch(name);
}

/** A função acima usa regex para verificar se o nome contém apenas
 * letras e não possui caracteres especiais ou números. Em seguida,
 * ela verifica se o nome tem pelo menos uma letra. **/

bool validatePassword(String password) {
  return password.length >= 6;
}

// A função acima verifica se a senha tem pelo menos 6 caracteres.

int _selectedOption = 1; // variável usada para escolher a permissão no cadastro
String? _role;

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPage();
}

class _CreateUserPage extends State<CreateUserPage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> addDataToFirestore() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('testeusuarios');
    final Map<String, dynamic> data = {
      'nome': nameController.text,
      'email': emailController.text,
      'acesso': _role,
    };
    await usersCollection.add(data);
    print('Dados adicionados com sucesso');
  }

  createUser(BuildContext context) async {
    try {
      await context.read<AuthService>().registrar(emailController.text, passwordController.text);
      showDialog(
        context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('titulo'),
              content: Text(
                'texto',
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        addDataToFirestore();

    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        backgroundColor: const Color(0xffb71717),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        color: Colors.white,
        child: ListView(children: <Widget>[
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset("assets/add-user-icon.png"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "titulo",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "texto",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 10,
          ),

          Form(
            key: formKey2,
            child: TextFormField(
              // autofocus: true,
              controller: nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (nome) =>
              nome != null && !validateName(nome)
                  ? 'O nome não pode estar vazio e deve conter apenas letras. O uso de caracteres especiais ou números também não é permitido.'
                  : null,
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Form(
            key: formKey,
            child: TextFormField(
              // autofocus: true,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              email != null && !EmailValidator.validate(email)
                  ? 'Insira um E-mail válido'
                  : null,
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Form(
            key: formKey3,
            child: TextFormField(
              // autofocus: true,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              email != null && !validatePassword(email)
                  ? 'Sua senha deve conter no mínimo 6 caracteres.'
                  : null,
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          Container(
            child: Text('Selecione um cargo para ser atribuído: ',
            style: TextStyle(
              fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,)
          ),
          ),

        SizedBox(
          height: 10,
        ),

          ListView(
            shrinkWrap: true,
            children: [
              RadioListTile(
                title: Text('Usuário',
                style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.normal,
                )
          ),
                value: 1, // Value associated with this option
                groupValue: _selectedOption, // Currently selected option
                onChanged: (value) {
                  setState(() {
                    _selectedOption = (value as int);
                  });
                },
              ),
              RadioListTile(
                title: Text('Administrador',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                )
                ),
                value: 2, // Value associated with this option
                groupValue: _selectedOption, // Currently selected option
                onChanged: (value) {
                  setState(() {
                    _selectedOption = (value as int);// Set the value of _role
                  });
                },
              ),
              // Add more RadioListTile widgets as needed
            ],
          ),

          // map function

          SizedBox(
            height: 30,
          ),

          Container(
            height: 40,
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text(
                "CADASTRAR",
                textAlign: TextAlign.right,
              ),
              onPressed: () {
                setState(() {
                  switch (_selectedOption) {
                    case 1:
                      _role = 'Usuario';
                      break;
                    case 2:
                      _role = 'Administrador';
                      break;
                  }
                });
                print(_role);
                createUser(context);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(327, 50),
                  backgroundColor: Color(0xffb71717),
                  elevation: 0,
                  side: const BorderSide(width: 1.0, color: Colors.white),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ))),
            ),
          ),
        ]),
      ),
    );
  }
}
