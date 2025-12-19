import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exercise_viewmodel.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseViewModel>(context, listen: false).loadInitialExercises();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        Provider.of<ExerciseViewModel>(context, listen: false).loadMoreExercises();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gymbeast'),
        actions: [
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Szukaj ćwiczenia...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                Provider.of<ExerciseViewModel>(context, listen: false).searchExercises(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<ExerciseViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.exercises.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage.isNotEmpty && viewModel.exercises.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Błąd: ${viewModel.errorMessage}', textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => viewModel.loadInitialExercises(),
                          child: const Text('Spróbuj ponownie'),
                        )
                      ],
                    ),
                  );
                }

                if (viewModel.exercises.isEmpty) {
                   return const Center(child: Text('Brak ćwiczeń na liście.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.exercises.length + (viewModel.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewModel.exercises.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    }

                    final exercise = viewModel.exercises[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            exercise.bodyPart.length > 2 ? exercise.bodyPart.substring(0, 2).toUpperCase() : 'EX',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${exercise.bodyPart} | ${exercise.equipment}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseDetailScreen(exerciseId: exercise.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
