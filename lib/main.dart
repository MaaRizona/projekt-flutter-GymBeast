import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'repositories/exercise_repository.dart';
import 'services/api_service.dart';
import 'services/local_storage_service.dart';
import 'services/analytics_service.dart';
import 'viewmodels/exercise_viewmodel.dart';
import 'screens/exercise_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();

    // Konfiguracja Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final localStorageService = LocalStorageService();
    final analyticsService = AnalyticsService();
    
    final repository = ExerciseRepository(
      apiService: apiService,
      localStorageService: localStorageService,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExerciseViewModel(
            repository: repository, 
            analyticsService: analyticsService
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gymbeast',
        theme: ThemeData(
          // Ulepszona estetyka
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.dark),
          useMaterial3: true,
          fontFamily: 'Roboto', 
        ),
        navigatorObservers: [
          analyticsService.analyticsObserver,
        ],
        home: const ExerciseListScreen(),
      ),
    );
  }
}
