import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/repositories/shared_preferences/shared_preferences_repository.dart';
import 'presentation/pages/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesRepositoryProvider
        .overrideWithValue(SharedPreferencesRepository(prefs)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(),
    );
  }
}
