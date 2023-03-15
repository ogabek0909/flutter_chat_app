import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presintation/firebase_options.dart';
import 'package:presintation/models/firebase_data.dart';
import 'package:presintation/providers/add_todo.dart';
import 'package:presintation/providers/auth.dart';
import 'package:presintation/providers/get_todo.dart';
import 'package:presintation/screens/auth_screen.dart';
import 'package:presintation/screens/overview_screen.dart';
import 'package:presintation/screens/add_todo_screen.dart';
import 'package:presintation/screens/todo_list_screen.dart';
import 'package:provider/provider.dart';

import 'models/category.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetTodo(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddTodo(),
        ),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Provider.of<Services>(context, listen: false).addTodo(Todo(
    //     title: 'title',
    //     description: 'description',
    //     notificationDate: DateTime.now(),
    //     category: 'category'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: '/AuthScreen',
        routes: [
          GoRoute(
            path: '/authScreen',
            name: AuthScreen.routeName,
            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser == null) {
                return '/AuthScreen';
              } else {
                return '/overviewScreen';
              }
            },
            builder: (context, state) => const AuthScreen(),
          ),
          GoRoute(
            path: '/overviewScreen',
            name: OverviewScreen.routeName,
            builder: (context, state) => OverviewScreen(),
            routes: [
              GoRoute(
                path: 'addTodoScreen',
                name: AddTodoScreen.routeName,
                builder: (context, state) => const AddTodoScreen(),
              ),
              GoRoute(
                path: 'todoListScreen',
                name: TodoListScreen.routeName,
                builder: (context, state) =>
                    TodoListScreen(item: state.extra as Category),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
