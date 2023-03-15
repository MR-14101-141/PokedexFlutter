abstract class PokemonListEvent {}

class PokemonListLoadEvent extends PokemonListEvent {}

class PokemonListLazyLoadEvent extends PokemonListEvent {}

class PokemonListRefreshEvent extends PokemonListEvent {}
