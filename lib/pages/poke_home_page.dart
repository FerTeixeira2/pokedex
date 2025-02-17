import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pokedex/models/nome_pokemon_model.dart';
import 'package:pokedex/pages/info_pokemon_page.dart';

class PokeHomePage extends StatelessWidget {
  const PokeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Future<List<ListPokemomModel>> _getPokemons() async {
    final dio = Dio();
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/');
    var results = response.data['results'];
    List<ListPokemomModel> listaPokemons = (results as List)
        .map((pokemon) => ListPokemomModel.fromMap(pokemon))
        .toList();
    await Future.delayed(Duration(seconds: 4));
    return listaPokemons;
  }

  Widget _buildBody() {
    return FutureBuilder<List<ListPokemomModel>>(
      future: _getPokemons(),
      builder: (context, response) {
        if (response.connectionState == ConnectionState.done) {
          var lista = response.data;
          if (lista == null || lista.isEmpty) {
            return Text("Nenhum Pokémon encontrado!");
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset(
                  'assets/images/pokeball.png',
                  width: 25,
                  height: 25,
                ),
                title: Text(lista[index].nome),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesPokemonPage(
                        nome: lista[index].nome,
                        url: lista[index].url,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
