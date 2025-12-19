import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/exercise_viewmodel.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseViewModel>(context, listen: false).loadExerciseDetails(widget.exerciseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły')),
      body: Consumer<ExerciseViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.detailError.isNotEmpty) {
            return Center(child: Text('Błąd: ${viewModel.detailError}'));
          }

          final detail = viewModel.currentDetail;
          if (detail == null) {
            return const Center(child: Text('Nie udało się pobrać danych.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail.gifUrl.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CachedNetworkImage(
                        imageUrl: detail.gifUrl,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                
                Text(
                  detail.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildSectionTitle('Mięsień docelowy'),
                Text(detail.target, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                _buildSectionTitle('Partia ciała'),
                Text(detail.bodyPart, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                _buildSectionTitle('Sprzęt'),
                Text(detail.equipment, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                if (detail.secondaryMuscles.isNotEmpty) ...[
                  _buildSectionTitle('Mięśnie pomocnicze'),
                  Wrap(
                    spacing: 8.0,
                    children: detail.secondaryMuscles.map((muscle) => Chip(label: Text(muscle))).toList(),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(),
                Text('ID: ${detail.id}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
