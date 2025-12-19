import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics? _analytics;

  AnalyticsService()
      : _analytics = (kIsWeb || Platform.isAndroid || Platform.isIOS)
            ? FirebaseAnalytics.instance
            : null;

  NavigatorObserver get analyticsObserver {
    if (_analytics != null) {
      return FirebaseAnalyticsObserver(analytics: _analytics);
    }
    return NavigatorObserver(); // Pusty observer dla Windows/Linux/MacOS
  }

  Future<void> logExerciseListLoaded({
    required int count,
    required String source,
  }) async {
    await _analytics?.logEvent(
      name: 'exercise_list_loaded',
      parameters: {
        'count': count,
        'source': source,
      },
    );
  }

  Future<void> logExerciseDetailOpened({
    required String exerciseId,
    required String exerciseName,
  }) async {
    await _analytics?.logEvent(
      name: 'exercise_detail_opened',
      parameters: {
        'exercise_id': exerciseId,
        'exercise_name': exerciseName,
      },
    );
  }

  Future<void> logExerciseSearchPerformed({
    required int queryLength,
    required int resultsCount,
  }) async {
    await _analytics?.logEvent(
      name: 'exercise_search_performed',
      parameters: {
        'query_length': queryLength,
        'results_count': resultsCount,
      },
    );
  }
}

