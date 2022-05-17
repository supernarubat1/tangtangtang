import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tangtangtang/providers/categoryProvider.dart';
import 'package:tangtangtang/screens/addScreen.dart';
import 'package:tangtangtang/screens/editScreen.dart';
import 'package:tangtangtang/screens/homeScreen.dart';
import 'package:tangtangtang/screens/initialScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final routes = {
    InitialScreen.id: (_) => const InitialScreen(),
    HomeScreen.id: (_) => const HomeScreen(),
    AddScreen.id: (_) => const AddScreen(),
    EditScreen.id: (_) => const EditScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        title: 'TangTangTang',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.grey),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en', 'US'),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('th', 'TH'),
        ],
        routes: routes,
        home: const InitialScreen(),
      ),
    );
  }
}
