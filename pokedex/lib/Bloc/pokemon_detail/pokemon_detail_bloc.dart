import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokedex/Bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokedex/Repository/pokemon_detail_repository.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonDetailRepository _repository;

  PokemonDetailBloc(this._repository) : super(InitPokemonDetailState()) {
    on<PokemonDetailLoadEvent>(_onPokemonDetailLoad);
    on<PokemonDetailRefreshEvent>(_onPokemonDetailRefresh);
  }

  void _onPokemonDetailLoad(
      PokemonDetailLoadEvent event, Emitter<PokemonDetailState> emit) async {
    emit(LoadingPokemonDetailState());
    try {
      final response = await _repository.loadDetail(event.url);
      emit(ResponsePokemonDetailState(response));
    } catch (e) {
      emit(ErrorPokemonDetailState(e.toString()));
    }
  }

  void _onPokemonDetailRefresh(
      PokemonDetailRefreshEvent event, Emitter<PokemonDetailState> emit) async {
    emit(LoadingPokemonDetailState());
    try {
      final response = await _repository.loadDetail(event.url);
      emit(ResponsePokemonDetailState(response));
    } catch (e) {
      emit(ErrorPokemonDetailState(e.toString()));
    }
  }
}
