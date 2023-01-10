import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appmumbuca/register_page.dart';

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

  login(String email, String senha) async {

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found'){
        throw AuthException('Email não registrado. Busque o Administrador do Aplicativo para realizar o cadastro');
      } else if (e.code == 'wrong-password'){
        throw AuthException('Senha incorreta');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  registrar(String email, String senha) async {
    try{
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    _getUser();
  }
    on FirebaseAuthException catch(e){
      if (e.code == 'invalid-password'){
        throw AuthException('A senha deve conter pelo menos 6 caracteres.');
      } else if (e.code == 'email-already-in-use'){
        throw AuthException('Email já está em uso.');
      } else if (email == ''){
        throw AuthException('Para cadastrar um usuário, é preciso inserir um email válido.');
      }
    }
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