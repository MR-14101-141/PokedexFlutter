import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokedex/Bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokedex/Repository/pokemon_list_repository.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonListRepository _repository;

  PokemonListBloc(this._repository) : super(InitPokemonListState()) {
    on<PokemonListLoadEvent>(_onPokemonListLoad);
    on<PokemonListLazyLoadEvent>(_onPokemonListLazyLoad);
    on<PokemonListRefreshEvent>(_onPokemonListRefresh);
  }

  void _onPokemonListLoad(
      PokemonListLoadEvent event, Emitter<PokemonListState> emit) async {
    emit(LoadingPokemonListState());
    try {
      final response = await _repository.loadList();
      emit(ResponsePokemonListState(response));
    } catch (e) {
      emit(ErrorPokemonListState(e.toString()));
    }
  }

  void _onPokemonListLazyLoad(
      PokemonListLazyLoadEvent event, Emitter<PokemonListState> emit) async {
    try {
      final response = await _repository.lazyLoad();
      emit(ResponsePokemonListState(response));
    } catch (e) {
      emit(ErrorPokemonListState(e.toString()));
    }
  }

  void _onPokemonListRefresh(
      PokemonListRefreshEvent event, Emitter<PokemonListState> emit) async {
    emit(LoadingPokemonListState());
    try {
      final response = await _repository.loadList();
      emit(ResponsePokemonListState(response));
    } catch (e) {
      emit(ErrorPokemonListState(e.toString()));
    }
  }
}
