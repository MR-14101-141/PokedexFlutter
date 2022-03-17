import 'package:flutter/material.dart';

@immutable
class TypeColors {
  final normal = const Color(0xFFb3b5b2);
  final fire = const Color(0xFFF4934D);
  final fighting = const Color(0xFFEB4971);
  final water = const Color(0xFF75b1e5);
  final flying = const Color(0xFFB8A5F2);
  final grass = const Color(0xFF7fca79);
  final poison = const Color(0xFFc582d9);
  final electric = const Color(0xFFF9DF78);
  final ground = const Color(0xFFF78551);
  final psychic = const Color(0xFFfb9d9a);
  final rock = const Color(0xFFd4c9a1);
  final ice = const Color(0xFF91d9cd);
  final bug = const Color(0xFFB5C534);
  final dragon = const Color(0xFF8656FA);
  final ghost = const Color(0xFF7f8ac9);
  final dark = const Color(0xFF7a7981);
  final steel = const Color(0xFF78aab5);
  final fairy = const Color(0xFFf1a6eb);

  const TypeColors();

  Map<String, dynamic> colorMap() {
    return {
      'normal': normal,
      'fire': fire,
      'fighting': fighting,
      'water': water,
      'flying': flying,
      'grass': grass,
      'poison': poison,
      'electric': electric,
      'ground': ground,
      'psychic': psychic,
      'rock': rock,
      'ice': ice,
      'bug': bug,
      'dragon': dragon,
      'ghost': ghost,
      'dark': dark,
      'steel': steel,
      'fairy': fairy,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = colorMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
