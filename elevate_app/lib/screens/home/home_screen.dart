import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_model.dart';
import '../workouts/workout_detail_screen.dart';
import '../workouts/my_workouts_screen.dart';
import '../workouts/create_workout_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        context.read<WorkoutProvider>().loadUserWorkouts(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeContent(),
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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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
              margin: const EdgeInsets.only(top: 40),
            ),

            // Header with profile
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: authProvider.userData?.photoUrl != null
                            ? CachedNetworkImageProvider(authProvider.userData!.photoUrl!)
                            : null,
                        child: authProvider.userData?.photoUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 160,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Bem-vindo, ${authProvider.userData?.username ?? 'Usuário'}!',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Title
            Text(
              'Treinos do dia',
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

            // View details button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyWorkoutsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Ver detalhes'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(148, 48),
                ),
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