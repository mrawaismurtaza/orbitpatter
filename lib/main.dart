import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/core/routes/app_router.dart';
import 'package:orbitpatter/core/theme/app_theme.dart';
import 'package:orbitpatter/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MultiRepositoryProvider(
    //   providers: [], 
    //   child: MultiBlocProvider(
    //     providers: [],
    //     child: 
    return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        // ),
      // ),
    );
  }
}
