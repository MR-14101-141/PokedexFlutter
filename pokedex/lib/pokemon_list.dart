import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'Animation/_slideanimation.dart';
import 'dart:developer';

class PokeListScreen extends StatefulWidget {
  const PokeListScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PokeListScreen> createState() => _PokeListState();
}

class _PokeListState extends State<PokeListScreen> {
  late ScrollController _scrollController;
  late List list = List.empty();

  Future<void> _pullRefresh() async {
    list = List.empty();
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
    if (mounted) {
      log('TEST:$list');
      setState(() {
        list = List.from(list)..addAll(json.decode(response.body)['results']);
      });
    }
  }

  Future<void> lazyLoad() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));
    if (mounted) {
      setState(() {
        list = List.from(list)..addAll(json.decode(response.body)['results']);
      });
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }

  @override
  initState() {
    super.initState();
    lazyLoad();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: _listPoke(),
          ))
        ],
      ),
    );
  }

  Widget _listPoke() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return list != List.empty()
            ? Column(children: [
                SlideAnimation(
                    delay: 3,
                    child: Container(
                        height: 20.h,
                        width: 100.w,
                        color: Colors.white,
                        child: InkWell(
                            onTap: () {},
                            child: Column(children: [
                              Text(list[i]['name'].toString()),
                              Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${list[i]['url'].toString().split('/')[6]}.png',
                                width: 15.h,
                                height: 15.h,
                              )
                            ])))),
                Padding(padding: EdgeInsets.only(bottom: 1.h))
              ])
            : const SizedBox(
                height: 0,
                width: 0,
              );
      },
    );
  }
}
