import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/exercise_model.dart';

class ExerciseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<ExerciseModel> _exercises = [];
  bool _isLoading = false;

  List<ExerciseModel> get exercises => _exercises;
  bool get isLoading => _isLoading;

  void loadWorkoutExercises(String workoutId) {
    _firestoreService.getWorkoutExercises(workoutId).listen((exercises) {
      _exercises = exercises;
      notifyListeners();
    });
  }

  Future<void> createExercise({
    required String nome,
    String? descricao,
    String? categoria,
    String? carga,
    int? series,
    String? imagemexer,
    required String workoutId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final exercise = ExerciseModel(
        id: '',
        nome: nome,
        descricao: descricao,
        categoria: categoria,
        carga: carga,
        series: series,
        imagemexer: imagemexer,
        treinoRef: FirebaseFirestore.instance.collection('treinos').doc(workoutId),
        criadoEm: DateTime.now(),
      );

      await _firestoreService.createExercise(exercise);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateExercise(ExerciseModel exercise) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.updateExercise(exercise);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteExercise(String exerciseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.deleteExercise(exerciseId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ExerciseModel?> getExercise(String exerciseId) async {
    try {
      return await _firestoreService.getExercise(exerciseId);
    } catch (e) {
      rethrow;
    }
  }

  void clearExercises() {
    _exercises = [];
    notifyListeners();
  }
}