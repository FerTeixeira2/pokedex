import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pokedex/models/nome_pokemon_model.dart';
import 'info_pokemon_page.dart';

class PokeHomePage extends StatefulWidget {
  const PokeHomePage({super.key});

  @override
  State<PokeHomePage> createState() => _PokeHomePageState();
}

class _PokeHomePageState extends State<PokeHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<ListPokemomModel> pokemonList = [];
  List<ListPokemomModel> filteredPokemonList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
    _scrollController.addListener(_scrollListener);
    searchController.addListener(_filterPokemons);
  }

  Future<void> _fetchPokemonList() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();
      final response =
          await dio.get('https://pokeapi.co/api/v2/pokemon', queryParameters: {
        'limit': 1000,
        'offset': 0,
      });

      setState(() {
        pokemonList.addAll(response.data['results']
            .map<ListPokemomModel>(
                (pokemon) => ListPokemomModel.fromMap(pokemon))
            .toList());
        filteredPokemonList = List.from(pokemonList);
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar Pokémons: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPokemons() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPokemonList = pokemonList
          .where((pokemon) => pokemon.nome.toLowerCase().contains(query))
          .toList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  Color getPokemonTypeColor(List<dynamic> types) {
    if (types.isNotEmpty) {
      String type = types[0]['type']['name'];
      switch (type) {
        case 'grass':
          return const Color.fromARGB(255, 55, 212, 60);
        case 'fire':
          return const Color.fromARGB(255, 240, 73, 7);
        case 'water':
          return const Color.fromARGB(255, 10, 115, 201);
        case 'electric':
          return Colors.amber;
        case 'poison':
          return const Color.fromARGB(255, 175, 37, 202);
        case 'bug':
          return const Color.fromARGB(255, 138, 204, 63);
        case 'flying':
          return const Color.fromARGB(255, 113, 191, 228);
        case 'normal':
          return const Color.fromARGB(255, 201, 199, 199);
        case 'fighting':
          return const Color.fromARGB(255, 218, 6, 6);
        case 'rock':
          return const Color.fromARGB(255, 199, 99, 63);
        case 'psychic':
          return Colors.deepPurpleAccent.shade100;
        case 'fairy':
          return const Color.fromARGB(255, 214, 106, 182);
        case 'ghost':
          return const Color.fromARGB(255, 109, 16, 231);
        case 'ground':
          return const Color.fromARGB(255, 148, 61, 11);
        case 'ice':
          return const Color.fromARGB(255, 7, 212, 202);
        default:
          return Colors.grey;
      }
    }
    return Colors.grey;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeDex'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredPokemonList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: filteredPokemonList.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredPokemonList.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final pokemon = filteredPokemonList[index];
                      final name = pokemon.nome;
                      final url = pokemon.url;

                      final typeResponse = Dio().get(url);

                      return FutureBuilder(
                        future: typeResponse,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Erro ao carregar tipos'));
                          }

                          final pokemonDetails = snapshot.data?.data;
                          final types = pokemonDetails['types'];

                          Color backgroundColor = getPokemonTypeColor(types);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesPokemonPage(
                                    nome: name,
                                    url: url,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: backgroundColor,
                              margin: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${url.split('/')[6]}.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    name.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
