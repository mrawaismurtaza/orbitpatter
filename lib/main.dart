import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orbitpatter/core/routes/app_router.dart';
import 'package:orbitpatter/core/services/hive_service.dart';
import 'package:orbitpatter/core/services/location_service.dart';
import 'package:orbitpatter/core/theme/app_theme.dart';
import 'package:orbitpatter/core/utils/logger.dart';
import 'package:orbitpatter/data/models/location.dart';
import 'package:orbitpatter/data/repositories/auth_repository.dart';
import 'package:orbitpatter/data/repositories/chat_repository.dart';
import 'package:orbitpatter/data/repositories/open_trip_map_repo.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/chat/chat_bloc.dart';
import 'package:orbitpatter/features/blocs/location/location_bloc.dart';
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

  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());
  await Hive.openBox<LocationModel>('location_box');

  _setupDependencies();

  LoggerUtil.init();

  runApp(
    DevicePreview(
      enabled: false, // Set to true to enable Device Preview
      builder: (context) => const MyApp(),
    ),
  );
}

void _setupDependencies() {
  getIt.registerSingleton<AuthRepository>(AuthRepository());
  getIt.registerSingleton<LocationService>(LocationService()); // Add this
  getIt.registerSingleton<HiveService>(HiveService());
  getIt.registerSingleton<OpenTripMapRepo>(OpenTripMapRepo());
  getIt.registerSingleton<ChatRepository>(ChatRepository());


  // Register other dependencies as needed
  getIt.registerFactory<LoginBloc>(() => LoginBloc(
    authRepository: getIt<AuthRepository>(),
  ));
  getIt.registerFactory<LocationBloc>(() => LocationBloc(getIt<LocationService>()));
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<ChatRepository>(), getIt<AuthRepository>()));
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
        RepositoryProvider(
          create: (context) => OpenTripMapRepo(),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<LoginBloc>()),
          BlocProvider<LocationBloc>(
            create: (_) => getIt<LocationBloc>(),
          ),
          BlocProvider<ChatBloc>(
            create: (_) => getIt<ChatBloc>(),
          ),
        ],
        child:  MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,

          // home: const Practice(),
        ),
      ),
    );
  }
}



// class Practice extends StatefulWidget {
//   const Practice({super.key});

//   @override
//   State<Practice> createState() => _PracticeState();
// }

// class _PracticeState extends State<Practice> {

//   List<String> myList = [
//             'Item 1',
//             'Item 2',
//             'Item 3',
//   ];


//   Map<String, dynamic> myMap = {
//     'key1': {
//       'subkey1': 'subvalue1',
//       'subkey2': 'subvalue2',
//     },
//     'key2': 'value2',
//     'key3': 'value3',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _myFunction();

//     myFunction(Callback);
//   }

//   void Callback(String message){
//     LoggerUtil.error('Callback function called with message: $message');
//   }

//   void myFunction(Function(String) Callback) {
//     LoggerUtil.info('myFunction called');
//     Callback('Hello from myFunction');
//   }

//   void _myFunction() {
//     // List<String> newList = myList.map((item) =>
//     //   item.toUpperCase() + ' - Modified'
//     // ).toList();

//     // newList.forEach((item) {
//     //   LoggerUtil.error(item);
//     // });

//     myMap.forEach((key, value) {
//       LoggerUtil.info('Key: $key, Value: $value');
//     });

//     LoggerUtil.debug(myMap['key1']['subkey1']);

//     print(myMap['key1']['subkey2']);

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.separated(
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(myList[index]),
//             onTap: () => LoggerUtil.info('Tapped on ${myList[index]}'),
//             trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16.0),
//           );
//         },
//         itemCount: myList.length,
//         separatorBuilder: (context, index) => SizedBox(height: 8.0),
//         ),
//     );
//   }
// }



