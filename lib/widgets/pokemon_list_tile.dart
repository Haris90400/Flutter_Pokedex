// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  const PokemonListTile({
    Key? key,
    required this.pokemonURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonURL),
    );
    return pokemon.when(data: (data) {
      return _tile(context, data, false);
    }, error: (error, stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, null, true);
    });
  }

  Widget _tile(BuildContext context, Pokemon? pokemon, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        title: Text(
          pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currently loading name for pokemon.",
        ),
        subtitle: Text(
          "Has ${pokemon?.moves?.length.toString() ?? 0} moves",
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
          ),
        ),
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : const CircleAvatar(),
      ),
    );
  }
}
