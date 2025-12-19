import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';
import '../models/exercise_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String _apiKey = 'INSERT_API_KEY_HERE';
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': _apiKey,
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
  };

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Pobranie listy ćwiczeń
  Future<List<Exercise>> fetchExercises({int limit = 10, int offset = 0}) async {
    final url = Uri.parse('$_baseUrl/exercises?limit=$limit&offset=$offset');
    
    try {
      final response = await _client.get(url, headers: _headers).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Exercise.fromJson(e)).toList();
      } else {
        throw Exception('Błąd ładowania ćwiczeń: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd sieci: $e');
    }
  }

  // Pobranie szczegółów ćwiczenia
  Future<ExerciseDetail> fetchExerciseDetail(String id) async {
    final url = Uri.parse('$_baseUrl/exercises/exercise/$id');

    try {
      final response = await _client.get(url, headers: _headers).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ExerciseDetail.fromJson(json);
      } else {
        throw Exception('Błąd ładowania szczegółów ćwiczenia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd sieci: $e');
    }
  }
}
