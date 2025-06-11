import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Workout operations
  Future<String> createWorkout(WorkoutModel workout) async {
    try {
      final docRef = await _firestore.collection('treinos').add(workout.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await _firestore
          .collection('treinos')
          .doc(workout.id)
          .update(workout.toFirestore());
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      // Delete all exercises in this workout first
      final exercises = await _firestore
          .collection('exercicios')
          .where('TreinoRef', isEqualTo: _firestore.collection('treinos').doc(workoutId))
          .get();

      for (final doc in exercises.docs) {
        await doc.reference.delete();
      }

      // Then delete the workout
      await _firestore.collection('treinos').doc(workoutId).delete();
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }

  Stream<List<WorkoutModel>> getUserWorkouts(String userId) {
    return _firestore
        .collection('treinos')
        .where('usuarioRef', isEqualTo: _firestore.collection('usuario').doc(userId))
        .orderBy('criado_em', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutModel.fromFirestore(doc))
            .toList());
  }

  Future<WorkoutModel?> getWorkout(String workoutId) async {
    try {
      final doc = await _firestore.collection('treinos').doc(workoutId).get();
      if (doc.exists) {
        return WorkoutModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get workout: $e');
    }
  }

  // Exercise operations
  Future<String> createExercise(ExerciseModel exercise) async {
    try {
      final docRef = await _firestore.collection('exercicios').add(exercise.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create exercise: $e');
    }
  }

  Future<void> updateExercise(ExerciseModel exercise) async {
    try {
      await _firestore
          .collection('exercicios')
          .doc(exercise.id)
          .update(exercise.toFirestore());
    } catch (e) {
      throw Exception('Failed to update exercise: $e');
    }
  }

  Future<void> deleteExercise(String exerciseId) async {
    try {
      await _firestore.collection('exercicios').doc(exerciseId).delete();
    } catch (e) {
      throw Exception('Failed to delete exercise: $e');
    }
  }

  Stream<List<ExerciseModel>> getWorkoutExercises(String workoutId) {
    return _firestore
        .collection('exercicios')
        .where('TreinoRef', isEqualTo: _firestore.collection('treinos').doc(workoutId))
        .orderBy('criado_em', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseModel.fromFirestore(doc))
            .toList());
  }

  Future<ExerciseModel?> getExercise(String exerciseId) async {
    try {
      final doc = await _firestore.collection('exercicios').doc(exerciseId).get();
      if (doc.exists) {
        return ExerciseModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get exercise: $e');
    }
  }
}