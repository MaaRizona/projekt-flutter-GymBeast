import '../models/exercise.dart';
import '../models/exercise_detail.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ExerciseRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  ExerciseRepository({
    ApiService? apiService,
    LocalStorageService? localStorageService,
  })  : _apiService = apiService ?? ApiService(),
        _localStorageService = localStorageService ?? LocalStorageService();

  Future<List<Exercise>> getExercises({int limit = 10, int offset = 0, Function(String source)? onSource}) async {
    try {
      final exercises = await _apiService.fetchExercises(limit: limit, offset: offset);
      
      // Filtrowanie zaszumionych danych
      final filtered = exercises.where((e) => e.name.trim().length > 3).toList();

      // Cache'ujemy tylko pierwszą stronę
      if (offset == 0 && filtered.isNotEmpty) {
        await _localStorageService.saveExercises(filtered);
      }

      onSource?.call('api');
      return filtered;
    } catch (e) {
      if (offset == 0) {
        final cached = await _localStorageService.getExercises();
        if (cached.isNotEmpty) {
          onSource?.call('cache');
          return cached;
        }
      }
      rethrow;
    }
  }

  Future<ExerciseDetail> getExerciseDetails(String id) async {
    return await _apiService.fetchExerciseDetail(id);
  }
}
