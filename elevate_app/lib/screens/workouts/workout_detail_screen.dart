import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/workout_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../models/workout_model.dart';
import '../../models/exercise_model.dart';
import '../exercises/edit_exercises_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/bottom_navigation.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  WorkoutModel? workout;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkout();
    context.read<ExerciseProvider>().loadWorkoutExercises(widget.workoutId);
  }

  Future<void> _loadWorkout() async {
    try {
      final loadedWorkout = await context.read<WorkoutProvider>().getWorkout(widget.workoutId);
      if (mounted) {
        setState(() {
          workout = loadedWorkout;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar treino: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      WorkoutDetailContent(workout: workout, workoutId: widget.workoutId),
      const HomeScreen(), // Placeholder for create
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            if (index == 0) {
              setState(() {
                _currentIndex = index;
              });
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          }
        },
      ),
    );
  }
}

class WorkoutDetailContent extends StatelessWidget {
  final WorkoutModel? workout;
  final String workoutId;

  const WorkoutDetailContent({
    super.key,
    required this.workout,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Status bar line
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).colorScheme.error,
              margin: const EdgeInsets.only(top: 32),
            ),

            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF4282335039),
                  ),
                ),
              ),
            ),

            // Title
            Text(
              'Meu treino',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 32,
                color: const Color(0xFF4282335039),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Workout info card
            if (workout != null)
              Container(
                width: 284,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF4293717228),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Image
                      Container(
                        width: 101.4,
                        height: 108,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: workout!.imagemtrei != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: workout!.imagemtrei!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.fitness_center,
                                    size: 50,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.fitness_center,
                                size: 50,
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              workout!.titulo,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4292613180),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (workout!.descricao != null)
                              Text(
                                workout!.descricao!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: const Color(0xFF4282335039),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('d/M/y').format(workout!.criadoEm),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4282335039),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Exercises list
            Expanded(
              child: Container(
                width: 340,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer<ExerciseProvider>(
                  builder: (context, exerciseProvider, child) {
                    if (exerciseProvider.exercises.isEmpty) {
                      return const Center(
                        child: Text('Nenhum exercício encontrado'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: exerciseProvider.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exerciseProvider.exercises[index];
                        return ExerciseCard(exercise: exercise);
                      },
                    );
                  },
                ),
              ),
            ),

            // Edit exercises button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExercisesScreen(workoutId: workoutId),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar exercicios'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(192, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.exercise.concluido;
  }

  Future<void> _toggleCompleted() async {
    try {
      final updatedExercise = widget.exercise.copyWith(
        concluido: !isCompleted,
      );
      
      await context.read<ExerciseProvider>().updateExercise(updatedExercise);
      
      setState(() {
        isCompleted = !isCompleted;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar exercício: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 284,
      height: 140,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4293717228),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image
            Container(
              width: 101.4,
              height: 108,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.exercise.imagemexer != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.exercise.imagemexer!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.fitness_center,
                          size: 50,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.fitness_center,
                      size: 50,
                    ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.exercise.nome,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4292613180),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (widget.exercise.categoria != null)
                          Text(
                            widget.exercise.categoria!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF4282335039),
                            ),
                          ),
                        if (widget.exercise.series != null)
                          Text(
                            'Series: ${widget.exercise.series}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF4282335039),
                            ),
                          ),
                        if (widget.exercise.carga != null)
                          Text(
                            'Carga: ${widget.exercise.carga}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF4282335039),
                            ),
                          ),
                        Text(
                          DateFormat('d/M/y').format(widget.exercise.criadoEm),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF4282335039),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isCompleted,
                    onChanged: (value) => _toggleCompleted(),
                    activeColor: const Color(0xFF4292613180),
                    checkColor: const Color(0xFF4282335039),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}