import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Cubit/pokemon_list_cubit.dart';
import 'package:pokedex/Cubit/pokemon_list_state.dart';
import 'package:sizer/sizer.dart';
import 'package:pokedex/Animations/_fadeanimation.dart';
import 'pokemon_detail.dart';

class PokeListScreen extends StatefulWidget {
  const PokeListScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PokeListScreen> createState() => _PokeListState();
}

class _PokeListState extends State<PokeListScreen> {
  late ScrollController _scrollController;

  selectPoke(String url) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => PokeDetailScreen(
          url: url,
        ),
        transitionsBuilder: (context, animation1, animation2, child) =>
            ScaleTransition(
                scale: animation1, alignment: Alignment.center, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  _scrollListener() {
    final cubit = context.read<PokemonListCubit>();
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      cubit.lazyLoadPokemonList();
    }
  }

  @override
  initState() {
    super.initState();
    final cubit = context.read<PokemonListCubit>();
    cubit.fetchPokemonList();
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PokemonListCubit>();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('POKEDEX'),
          ),
          backgroundColor: Colors.cyan.shade50,
          body: BlocBuilder<PokemonListCubit, PokemonListState>(
              builder: (context, state) {
            if (state is ErrorPokemonListState) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: Text(state.error))]);
            } else if (state is ResponsePokemonListState) {
              return RefreshIndicator(
                onRefresh: cubit.fetchPokemonList,
                child: listPoke(state.list),
              );
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Center(child: CircularProgressIndicator())]);
            }
          })),
    );
  }

  Widget listPoke(list) {
    if (list.isEmpty) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Center(child: Text('Empty Data'))]);
    } else {
      return ListView(controller: _scrollController, children: [
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 5.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Column(children: [
                FadeAnimation(
                    delay: 3,
                    child: Ink(
                        height: 20.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: InkWell(
                            focusColor: Colors.white,
                            borderRadius: BorderRadius.circular(10.sp),
                            onTap: () {
                              selectPoke(list[index]['url']);
                            },
                            child: Column(children: [
                              Padding(padding: EdgeInsets.only(top: 1.5.h)),
                              Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${list[index]['url'].toString().split('/')[6]}.png',
                                width: 15.h,
                                height: 15.h,
                              ),
                              Text(
                                  list[index]['name'].toString().toUpperCase()),
                            ])))),
              ]);
            }),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [Center(child: CircularProgressIndicator())])
      ]);
    }
  }
}
