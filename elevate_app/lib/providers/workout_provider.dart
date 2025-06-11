import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/workout_model.dart';

class WorkoutProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;

  List<WorkoutModel> get workouts => _workouts;
  bool get isLoading => _isLoading;

  void loadUserWorkouts(String userId) {
    _firestoreService.getUserWorkouts(userId).listen((workouts) {
      _workouts = workouts;
      notifyListeners();
    });
  }

  Future<void> createWorkout({
    required String titulo,
    String? descricao,
    String? imagemtrei,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final workout = WorkoutModel(
        id: '',
        titulo: titulo,
        descricao: descricao,
        imagemtrei: imagemtrei,
        usuarioRef: FirebaseFirestore.instance.collection('usuario').doc(userId),
        criadoEm: DateTime.now(),
      );

      await _firestoreService.createWorkout(workout);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.updateWorkout(workout);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.deleteWorkout(workoutId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<WorkoutModel?> getWorkout(String workoutId) async {
    try {
      return await _firestoreService.getWorkout(workoutId);
    } catch (e) {
      rethrow;
    }
  }
}