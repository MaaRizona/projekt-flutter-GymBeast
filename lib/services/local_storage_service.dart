import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';

class LocalStorageService {
  static const String _paramExercises = 'cached_exercises';

  Future<void> saveExercises(List<Exercise> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(exercises.map((e) => e.toJson()).toList());
    await prefs.setString(_paramExercises, jsonString);
  }

  Future<List<Exercise>> getExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_paramExercises);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Exercise.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
