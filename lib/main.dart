import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supercalc/models/item_arguments.dart';
import 'package:supercalc/pages/home.dart';
import 'package:supercalc/pages/itemPage.dart';
import 'package:supercalc/repositories/items_repository.dart';
import 'package:supercalc/repositories/lista_repository.dart';

import 'database/db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  runApp(const MyApp());
}

initialize() async {
  await getDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListaRepository()),
        ChangeNotifierProvider(create: (_) => ItemsRepository())
      ],
      child: MaterialApp(
          title: 'SuperCalc',
          theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Color.fromARGB(255, 8, 115, 12)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.amber[900]),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(
                    builder: (_) => const HomePage(
                          title: 'Listas',
                        ));
              case '/items':
                final ItemArguments args = settings.arguments as ItemArguments;
                return MaterialPageRoute(
                    builder: (_) => ItemPage(
                          listId: args.listId,
                          title: args.title,
                        ));
              default:
                return null;
            }
          }),
    );
  }
}
