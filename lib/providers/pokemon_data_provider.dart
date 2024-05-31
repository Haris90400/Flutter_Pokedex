import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_services.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    HTTPService _httpService = GetIt.instance.get<HTTPService>();

    Response? res = await _httpService.get(url);

    if (res != null && res.data != null) {
      return Pokemon.fromJson(
        res.data,
      );
    }
    return null;
  },
);

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider([]);
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  String FAVORITE_POKEMON_KEY = "FAVORITE_POKEMON_KEY";
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  FavoritePokemonsProvider(super.state) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result = await _databaseService.getList(FAVORITE_POKEMON_KEY);

    state = result ?? [];
  }

  void addFavoritePkemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMON_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVORITE_POKEMON_KEY, state);
  }
}
