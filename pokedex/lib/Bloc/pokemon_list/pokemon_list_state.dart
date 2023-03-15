abstract class PokemonListState {}

class InitPokemonListState extends PokemonListState {}

class LoadingPokemonListState extends PokemonListState {}

class ErrorPokemonListState extends PokemonListState {
  final String error;
  ErrorPokemonListState(this.error);
}

class ResponsePokemonListState extends PokemonListState {
  final List list;
  ResponsePokemonListState(this.list);
}
