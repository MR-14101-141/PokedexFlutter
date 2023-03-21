import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Cubit/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokedex/Repository/pokemon_detail_repository.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonDetailRepository _repository;

  PokemonDetailCubit(this._repository) : super(InitPokemonDetailState());

  Future<void> fetchPokemonDetail(widget) async {
    emit(LoadingPokemonDetailState());
    try {
      final response = await _repository.loadDetail(widget);
      emit(ResponsePokemonDetailState(response));
    } catch (e) {
      emit(ErrorPokemonDetailState(e.toString()));
    }
  }

  Future<void> refreshPokemonDetail(widget) async {
    emit(LoadingPokemonDetailState());
    try {
      final response = await _repository.loadDetail(widget);
      emit(ResponsePokemonDetailState(response));
    } catch (e) {
      emit(ErrorPokemonDetailState(e.toString()));
    }
  }
}
