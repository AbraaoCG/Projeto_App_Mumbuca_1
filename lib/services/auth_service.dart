import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/register_page.dart';

final _colecaoUsuarios = FirebaseFirestore.instance.collection('testeusuarios');

class AuthException implements Exception{
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService(){
    _authCheck();
  }

  _authCheck(){
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    } );
  }

  Future<bool> verifyRegisterFirestore(email) async {
    // Verifica-se se o usuário autenticado está na base de dados do firestore, se sim retorna true, senão false.
    var usuario = email;
    Query query = _colecaoUsuarios.where('email', isEqualTo: '$usuario');
    QuerySnapshot querySnapshot = await query.get();

    return querySnapshot.docs.isNotEmpty;
  }


  login(String email, String senha) async {
    if (await verifyRegisterFirestore(email)){ // Somente realiza o login se também há registro no Firestore.
      try{
        await _auth.signInWithEmailAndPassword(email: email, password: senha);

      } on FirebaseAuthException catch(e){
        if (e.code == 'user-not-found'){
          throw AuthException('Email não registrado. Busque o Administrador do Aplicativo para realizar o cadastro. Código: 1');
        } else if (e.code == 'wrong-password'){
          throw AuthException('Senha incorreta');
        }
      }
    } else{
      throw AuthException('Email não registrado. Busque o Administrador do Aplicativo para realizar o cadastro. Código: 2');
    }

  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  Future<void> addDataToFirestore(String email, String acesso, String nome) async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('testeusuarios');
    final Map<String, dynamic> data = {
      'nome': nome,
      'email': email,
      'acesso': acesso,
    };
    await usersCollection.add(data);
  }

  Future<bool> registrar(String email, String senha, String acesso, String nome) async {
    try{
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    _getUser();
    return false;
  }
    on FirebaseAuthException catch(e){
      if (e.code == 'invalid-password'){
        throw AuthException('A senha deve conter pelo menos 6 caracteres.');
      } else if (e.code == 'email-already-in-use'){
        // Se email já está cadastrado no FirebaseAuth, verifica-se se esse email existe no Firestore. Caso não exista, é recadastrado no FirebaseFirestore
        if (await verifyRegisterFirestore(email)){
          throw AuthException('Email já está em uso.');
        } else{ // Recadastro Firestore
          addDataToFirestore(email,acesso,nome);
          return true;
        }
      } else if (email == ''){
        throw AuthException('Para cadastrar um usuário, é preciso inserir um email válido.');
      }
    }
    return false;
  }

  resetPassword(String emailController) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: emailController);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Não existe um usuário cadastrado com esse email. Por favor, use outro email e tente novamente.');
      } else if (e.code == 'invalid-email'){
        throw AuthException('O email está incorreto. Escreva-o no formato padrão (exemplo: email@email.com).');
      } else if (emailController == ''){
        throw AuthException('Para recuperar a senha, é preciso inserir um email válido.');
      }
    }
  }

  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }
}