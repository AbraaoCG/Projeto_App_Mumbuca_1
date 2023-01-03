// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names


import 'package:appmumbuca/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appmumbuca/my_app.dart';
import 'package:appmumbuca/packages/firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Wait Firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService() ),
        ],
        child: const MyApp()
      ),
  );

  // Inicializar Firebase e gerar variáveis com dados úteis.
  FirebaseFirestore.instance;
  var Forms_collection = FirebaseFirestore.instance.collection('Formulários');
  var F1 = Forms_collection.doc("FormExemplo");
  var F2 = Forms_collection.doc("FormExemplo2");
  var F1_P1 = F1.collection("Perguntas").doc("PerguntExemplo1");
  var F1_P1_R = F1_P1.collection("Respostas");
  var F1P1R1 = F1_P1_R.doc("Resposta1");
  F1.set({
    'Nome_Formulário' : 'Formulário Exemplo 1',
    'Data_Criação'  : '20/12/2022'
  });
  F1_P1.set({
    'Enunciado': 'O que o Banco Mumbuca é para você?',
  });
  F1P1R1.set({
    'resposta_codigo' : 2
  });
}
