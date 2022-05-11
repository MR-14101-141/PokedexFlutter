import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:pokedex/Animations/_fadeanimation.dart';
import 'dart:developer';
import 'pokemon_detail.dart';

class PokeListScreen extends StatefulWidget {
  const PokeListScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PokeListScreen> createState() => _PokeListState();
}

class _PokeListState extends State<PokeListScreen> {
  late ScrollController _scrollController;
  List list = [];
  int offset = 10;

  Future<void> pullRefresh() async {
    setState(() {
      list = List.empty();
    });
    if (mounted) {
      final response = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
      log('TEST1');
      setState(() {
        offset = 10;
        list = List.from(list)..addAll(json.decode(response.body)['results']);
      });
    }
  }

  Future<void> loadList() async {
    if (mounted) {
      final response = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
      log('TEST3');
      setState(() {
        list.addAll(json.decode(response.body)['results']);
      });
    }
  }

  Future<void> lazyLoad() async {
    if (mounted) {
      final response = await http.get(Uri.parse(
          'https://pokeapi.co/api/v2/pokemon?limit=10&offset=$offset'));
      log('TEST2');
      setState(() {
        offset = offset + 10;
        list.addAll(json.decode(response.body)['results']);
      });
    }
  }

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
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      lazyLoad();
    }
  }

  @override
  initState() {
    super.initState();
    loadList();
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('POKEDEX'),
        ),
        backgroundColor: Colors.cyan.shade50,
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: listPoke(),
        ),
      ),
    );
  }

  Widget listPoke() {
    if (list.isEmpty) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [Center(child: CircularProgressIndicator())]);
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
        const Center(child: CircularProgressIndicator())
      ]);
    }
  }
}
