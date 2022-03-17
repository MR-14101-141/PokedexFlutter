import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'Animation/_fadeanimation.dart';
import 'dart:developer';

import 'Types/type_color.dart';

class PokeDetailScreen extends StatefulWidget {
  const PokeDetailScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<PokeDetailScreen> createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetailScreen> {
  late Map<String, dynamic> poke = {};

  Future<void> pullRefresh() async {
    setState(() {
      poke = {};
    });
    loadDetail().then((value) => null);
  }

  Future<void> loadDetail() async {
    if (mounted) {
      final response = await http.get(Uri.parse(widget.url));
      setState(() {
        poke['name'] = json.decode(response.body)['forms'][0]['name'];
        poke['types'] = json.decode(response.body)['types'];
      });
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('POKEDEX'),
      ),
      backgroundColor: Colors.cyan.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: RefreshIndicator(
            onRefresh: pullRefresh,
            child: detailPoke(),
          ))
        ],
      ),
    ));
  }

  Widget detailPoke() {
    if (poke.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CustomScrollView(
        slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: Alignment.center,
                color: const TypeColors().get(poke['types'][0]['type']['name']),
                child: Text(poke['types'][0]['type'].toString()),
              )),
        ],
      );
    }
  }
}
