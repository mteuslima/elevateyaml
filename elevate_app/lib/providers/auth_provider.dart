import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  UserModel? _userData;
  bool _isLoading = true;

  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _userData = await _authService.getUserData(user.uid);
      } else {
        _userData = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.createUserWithEmailAndPassword(email, password, username);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      await _authService.updateUserData(updatedUser);
      _userData = updatedUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}