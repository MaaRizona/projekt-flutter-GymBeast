import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/exercise_detail.dart';
import '../repositories/exercise_repository.dart';
import '../services/analytics_service.dart';

class ExerciseViewModel extends ChangeNotifier {
  final ExerciseRepository _repository;
  final AnalyticsService _analyticsService;

  ExerciseViewModel({
    ExerciseRepository? repository,
    AnalyticsService? analyticsService,
  })  : _repository = repository ?? ExerciseRepository(),
        _analyticsService = analyticsService ?? AnalyticsService();

  // --- List State ---
  List<Exercise> _allExercises = [];
  List<Exercise> _displayedExercises = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentOffset = 0;
  final int _limit = 10;
  bool _hasMore = true;

  List<Exercise> get exercises => _displayedExercises;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // --- Detail State ---
  ExerciseDetail? _currentDetail;
  bool _isDetailLoading = false;
  String _detailError = '';

  ExerciseDetail? get currentDetail => _currentDetail;
  bool get isDetailLoading => _isDetailLoading;
  String get detailError => _detailError;

  // --- List Logic ---

  Future<void> loadInitialExercises() async {
    _isLoading = true;
    _errorMessage = '';
    _currentOffset = 0;
    _hasMore = true;
    notifyListeners();

    try {
      String source = 'unknown';
      final newExercises = await _repository.getExercises(
        limit: _limit, 
        offset: _currentOffset,
        onSource: (src) => source = src,
      );
      _allExercises = newExercises;
      _displayedExercises = List.from(_allExercises);
      
      // Log event
      if (_currentOffset == 0) {
        _analyticsService.logExerciseListLoaded(
          count: newExercises.length,
          source: source,
        );
      }
      
      if (newExercises.length < _limit) {
        _hasMore = false;
      }
      _currentOffset += _limit;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreExercises() async {
    if (_isLoading || !_hasMore) return;
    
    // UI showing loading indicator at bottom based on scroll
    try {
      final newExercises = await _repository.getExercises(limit: _limit, offset: _currentOffset);
      
      if (newExercises.isEmpty) {
        _hasMore = false;
      } else {
        _allExercises.addAll(newExercises);
        _displayedExercises = List.from(_allExercises);
        _currentOffset += _limit;
        if (newExercises.length < _limit) _hasMore = false;
      }
    } catch (e) {
      // Just ignore pagination errors or show snackbar in UI
    } finally {
      notifyListeners();
    }
  }

  void searchExercises(String query) {
    if (query.isEmpty) {
      _displayedExercises = List.from(_allExercises);
    } else {
      _displayedExercises = _allExercises.where((e) {
        return e.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    
    _analyticsService.logExerciseSearchPerformed(
      queryLength: query.length, 
      resultsCount: _displayedExercises.length
    );
    notifyListeners();
  }

  // --- Detail Logic ---

  Future<void> loadExerciseDetails(String id) async {
    _isDetailLoading = true;
    _detailError = '';
    _currentDetail = null;
    notifyListeners();

    try {
      _currentDetail = await _repository.getExerciseDetails(id);
      
      if (_currentDetail != null) {
        _analyticsService.logExerciseDetailOpened(
          exerciseId: _currentDetail!.id.toString(),
          exerciseName: _currentDetail!.name,
        );
      }
    } catch (e) {
      _detailError = e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }
  
  void clearCurrentDetail() {
    _currentDetail = null;
    _detailError = '';
    _isDetailLoading = false;
    notifyListeners();
  }
}
