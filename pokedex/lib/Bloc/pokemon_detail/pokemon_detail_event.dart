abstract class PokemonDetailEvent {}

class PokemonDetailLoadEvent extends PokemonDetailEvent {
  final String url;
  PokemonDetailLoadEvent(this.url);
}

class PokemonDetailRefreshEvent extends PokemonDetailEvent {
  final String url;
  PokemonDetailRefreshEvent(this.url);
}
