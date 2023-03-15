import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Cubit/pokemon_list_state.dart';
import 'package:pokedex/Repository/pokemon_list_repository.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  final PokemonListRepository _repository;

  PokemonListCubit(this._repository) : super(InitPokemonListState());

  Future<void> fetchPokemonList() async {
    emit(LoadingPokemonListState());
    try {
      final response = await _repository.loadList();
      emit(ResponsePokemonListState(response));
    } catch (e) {
      emit(ErrorPokemonListState(e.toString()));
    }
  }

  Future<void> lazyLoadPokemonList() async {
    try {
      final response = await _repository.lazyLoad();
      emit(ResponsePokemonListState(response));
    } catch (e) {
      emit(ErrorPokemonListState(e.toString()));
    }
  }
}
