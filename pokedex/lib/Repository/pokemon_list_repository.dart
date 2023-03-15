import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class PokemonListRepository {
  List list = [];
  var offset = 10;

  Future<List> loadList() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
    log('TEST1');
    if (response.statusCode == 200) {
      offset = 10;
      list = json.decode(response.body)['results'];
      return list;
    } else {
      throw "Some thing went wrong code ${response.statusCode}";
    }
  }

  Future<List> lazyLoad() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$offset'));
    log('TEST2');
    if (response.statusCode == 200) {
      offset = offset + 10;
      list.addAll(json.decode(response.body)['results']);
      return list;
    } else {
      throw "Some thing went wrong code ${response.statusCode}";
    }
  }
}
