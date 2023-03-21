import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PokemonDetailRepository {
  Map<String, dynamic> poke = {};

  Future<Map<String, dynamic>> loadDetail(widget) async {
    final response = await http.get(Uri.parse(widget.url));
    log('TEST3');
    if (response.statusCode == 200) {
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
        poke['abilities']
            .add(json.decode(response.body)['abilities'][i]['ability']['name']);
      }
      return poke;
    } else {
      throw "Some thing went wrong code ${response.statusCode}";
    }
  }
}
