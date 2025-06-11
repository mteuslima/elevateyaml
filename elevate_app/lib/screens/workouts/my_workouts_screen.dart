import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_model.dart';
import 'workout_detail_screen.dart';
import 'create_workout_screen.dart';
import 'edit_workouts_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/bottom_navigation.dart';

class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const MyWorkoutsContent(),
      const CreateWorkoutScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class MyWorkoutsContent extends StatelessWidget {
  const MyWorkoutsContent({super.key});

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
              margin: const EdgeInsets.only(top: 8),
            ),

            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 16),
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
              'Meus treinos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 32,
                color: const Color(0xFF4282335039),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Workouts list
            Expanded(
              child: Container(
                width: 340,
                height: 360,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer<WorkoutProvider>(
                  builder: (context, workoutProvider, child) {
                    if (workoutProvider.workouts.isEmpty) {
                      return const Center(
                        child: Text('Nenhum treino encontrado'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: workoutProvider.workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workoutProvider.workouts[index];
                        return WorkoutCard(workout: workout);
                      },
                    );
                  },
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditWorkoutsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar treino'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateWorkoutScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Criar treino'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4282335039),
                      minimumSize: const Size(140, 48),
                    ),
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

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(workoutId: workout.id),
          ),
        );
      },
      child: Container(
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
                child: workout.imagemtrei != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: workout.imagemtrei!,
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
                      workout.titulo,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4292613180),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (workout.descricao != null)
                      Text(
                        workout.descricao!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: const Color(0xFF4282335039),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d/M/y').format(workout.criadoEm),
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
    );
  }
}