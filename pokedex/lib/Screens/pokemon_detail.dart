import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Cubit/pokemon_detail/pokemon_detail_cubit.dart';
import 'package:pokedex/Cubit/pokemon_detail/pokemon_detail_state.dart';
import 'package:sizer/sizer.dart';
import 'package:pokedex/Types/type_color.dart';

class PokeDetailScreen extends StatefulWidget {
  const PokeDetailScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<PokeDetailScreen> createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetailScreen> {
  Future<void> pullRefresh() async {
    final cubit = context.read<PokemonDetailCubit>();
    cubit.refreshPokemonDetail(widget);
  }

  Future<void> loadDetail() async {
    if (mounted) {
      final cubit = context.read<PokemonDetailCubit>();
      cubit.fetchPokemonDetail(widget);
    }
  }

  @override
  initState() {
    super.initState();
    loadDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
        builder: (context, state) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: (state is ResponsePokemonDetailState)
                    ? Text(state.poke['name'].toString().toUpperCase())
                    : const Text(''),
              ),
              backgroundColor: Colors.cyan.shade50,
              body: bodyDetail(state)));
    });
  }

  Widget bodyDetail(state) {
    if (state is ErrorPokemonDetailState) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Text(state.error))]);
    } else if (state is ResponsePokemonDetailState) {
      return RefreshIndicator(
        onRefresh: pullRefresh,
        child: detailPoke(state.poke),
      );
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Center(child: CircularProgressIndicator())]);
    }
  }

  Widget detailPoke(poke) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Stack(
            children: [
              Container(
                //alignment: Alignment.center,
                color: const TypeColors().get(poke['types'][0].toString()),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.sp),
                        topRight: Radius.circular(20.sp)),
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'NAME:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'TYPES: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ABILITIES: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(poke['name'].toString().toUpperCase()),
                              Text(poke['types']
                                  .join(", ")
                                  .toString()
                                  .toUpperCase()),
                              for (String item in poke['abilities'])
                                Text(item.toString().toUpperCase())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.0, -0.55),
                child: Image.network(
                  poke['imageUrl'],
                  width: 30.h,
                  height: 30.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
