import 'package:flutter/material.dart';
import 'package:pokedex/pokemon_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeDex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyBase(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyBase extends StatefulWidget {
  const MyBase({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyBase> createState() => _MyBaseState();
}

class _MyBaseState extends State<MyBase> {
  int _counter = 0;
  List screens = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    screens = [
      Navigator(
        onGenerateRoute: (settings) {
          Widget page = const PokeListScreen(title: '1');
          if (settings.name == 'PokeListScreen') {
            page = const PokeListScreen(title: '2');
          }
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(child: screens[0]),
      ),
    );
  }
}
