import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_model.dart';
import '../../widgets/bottom_navigation.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class EditWorkoutsScreen extends StatefulWidget {
  const EditWorkoutsScreen({super.key});

  @override
  State<EditWorkoutsScreen> createState() => _EditWorkoutsScreenState();
}

class _EditWorkoutsScreenState extends State<EditWorkoutsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const EditWorkoutsContent(),
      const HomeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            if (index == 1) {
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

class EditWorkoutsContent extends StatelessWidget {
  const EditWorkoutsContent({super.key});

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
              margin: const EdgeInsets.only(top: 24),
            ),

            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 16),
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
              'Editar treinos',
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
                height: 314,
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
                        return EditableWorkoutCard(workout: workout);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableWorkoutCard extends StatelessWidget {
  final WorkoutModel workout;

  const EditableWorkoutCard({
    super.key,
    required this.workout,
  });

  Future<void> _showEditDialog(BuildContext context) async {
    final titleController = TextEditingController(text: workout.titulo);
    final descriptionController = TextEditingController(text: workout.descricao ?? '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Treino'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedWorkout = workout.copyWith(
                  titulo: titleController.text.trim(),
                  descricao: descriptionController.text.trim().isEmpty 
                      ? null 
                      : descriptionController.text.trim(),
                );

                await context.read<WorkoutProvider>().updateWorkout(updatedWorkout);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treino atualizado com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao atualizar treino: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Treino'),
        content: Text('Tem certeza que deseja excluir o treino "${workout.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context.read<WorkoutProvider>().deleteWorkout(workout.id);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treino excluído com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir treino: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showEditDialog(context),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 24,
                          color: Color(0xFF4282335039),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(context),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 24,
                          color: Color(0xFF4292613180),
                        ),
                      ),
                    ],
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