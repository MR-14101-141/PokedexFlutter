import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:pokedex/Types/type_color.dart';

class PokeDetailScreen extends StatefulWidget {
  const PokeDetailScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<PokeDetailScreen> createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetailScreen> {
  Map<String, dynamic> poke = {};

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
        poke['imageUrl'] = json.decode(response.body)['sprites']['other']
            ['official-artwork']['front_default'];
        poke['types'] = [];
        for (int i = 0;
            i < json.decode(response.body)['types'].toList().length;
            i++) {
          poke['types']
              .add(json.decode(response.body)['types'][i]['type']['name']);
        }
        poke['abilities'] = [];
        for (int i = 0;
            i < json.decode(response.body)['abilities'].toList().length;
            i++) {
          poke['abilities'].add(
              json.decode(response.body)['abilities'][i]['ability']['name']);
        }
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
          title: (poke.isNotEmpty)
              ? Text(poke['name'].toString().toUpperCase())
              : const Text(''),
        ),
        backgroundColor: Colors.cyan.shade50,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: pullRefresh,
                child: detailPoke(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailPoke() {
    if (poke.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
}
