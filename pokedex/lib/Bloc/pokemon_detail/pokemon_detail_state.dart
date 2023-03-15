abstract class PokemonDetailState {}

class InitPokemonDetailState extends PokemonDetailState {}

class LoadingPokemonDetailState extends PokemonDetailState {}

class ErrorPokemonDetailState extends PokemonDetailState {
  final String error;
  ErrorPokemonDetailState(this.error);
}

class ResponsePokemonDetailState extends PokemonDetailState {
  final Map<String, dynamic> detail;
  ResponsePokemonDetailState(this.detail);
}
