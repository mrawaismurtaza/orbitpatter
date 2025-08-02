import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:orbitpatter/core/routes/app_router.dart';
import 'package:orbitpatter/core/theme/app_theme.dart';
import 'package:orbitpatter/data/repositories/auth_repository.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/firebase_options.dart';

final getIt = GetIt.instance;

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

  await dotenv.load(fileName: "assets/.env");

  _setupDependencies();

  runApp(const MyApp());
}

void _setupDependencies() {
  getIt.registerSingleton<AuthRepository>(AuthRepository());


  // Register other dependencies as needed
  getIt.registerFactory<LoginBloc>(() => LoginBloc(
    authRepository: getIt<AuthRepository>(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
      ], 
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<LoginBloc>()),
        ],
        child:  MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
