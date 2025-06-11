import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/bottom_navigation.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  int _currentIndex = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título para o treino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      await context.read<WorkoutProvider>().createWorkout(
        titulo: _titleController.text.trim(),
        descricao: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        userId: authProvider.user!.uid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        
        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar treino: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const CreateWorkoutContent(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _currentIndex == 1 
          ? const CreateWorkoutContent()
          : pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            if (index == 0) {
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

class CreateWorkoutContent extends StatefulWidget {
  const CreateWorkoutContent({super.key});

  @override
  State<CreateWorkoutContent> createState() => _CreateWorkoutContentState();
}

class _CreateWorkoutContentState extends State<CreateWorkoutContent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título para o treino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      await context.read<WorkoutProvider>().createWorkout(
        titulo: _titleController.text.trim(),
        descricao: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        userId: authProvider.user!.uid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        
        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar treino: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF4282335039),
                        ),
                      ),
                    ),

                    // Title
                    Text(
                      'Cadastrar treino',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 32,
                        color: const Color(0xFF4282335039),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titulo*',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4282335039),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _titleController,
                          hintText: 'Insira o titulo',
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Descrição',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4282335039),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _descriptionController,
                          hintText: 'Insira a descrição (opcional)',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 32),

                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: _isLoading ? null : _saveWorkout,
                            isLoading: _isLoading,
                            width: 132,
                            height: 48,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}