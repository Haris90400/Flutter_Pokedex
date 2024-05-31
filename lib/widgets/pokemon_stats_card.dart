import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonURL;

  PokemonStatsCard(this.pokemonURL);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonURL),
    );
    return AlertDialog(
      title: const Text("Statistics"),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Text(
                    "${s.stat?.name?.toUpperCase()}: ${s.baseStat}",
                  );
                }).toList() ??
                [],
          );
        },
        error: (error, stacktrace) {
          return Text('Error: $error');
        },
        loading: () {
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
