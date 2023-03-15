import 'package:flutter/material.dart';
import 'package:pokedex/Cubit/pokemon_list_cubit.dart';
import 'package:pokedex/Repository/pokemon_list_repository.dart';
import 'package:pokedex/Screens/pokemon_list.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonListCubit(PokemonListRepository()),
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'PokeDex',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: const MyBase(title: 'POKEDEX'),
        );
      }),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const PokeListScreen(title: '1');
  }
}
