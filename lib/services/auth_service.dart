import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      if (e.code == 'weak-password'){
        throw AuthException('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use'){
        throw AuthException('Email já está em uso.');
      }
    }
  }

  resetPassword(String emailController) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: emailController);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email Invalido.');
      }
    }
  }

  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }
}