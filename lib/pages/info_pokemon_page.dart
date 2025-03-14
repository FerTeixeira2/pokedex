import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pokedex/right_left_enum.dart';

class DetalhesPokemonPage extends StatefulWidget {
  final String nome;
  final String url;

  const DetalhesPokemonPage({
    super.key,
    required this.nome,
    required this.url,
  });

  @override
  State<DetalhesPokemonPage> createState() => _DetalhesPokemonPageState();
}

class _DetalhesPokemonPageState extends State<DetalhesPokemonPage> {
  bool isLoading = true;
  Map<String, dynamic> detalhesPokemon = {};
  Color backgroundColor = Colors.white;
  bool showAllMoves = false;
  double pesoEmQuilos = 0;
  double alturaEmMetros = 0;
  Map<String, dynamic> evolutions = {};

  var urlPokemon = "";

  @override
  void initState() {
    super.initState();
    urlPokemon = widget.url;
    _fetchPokemonDetails();
  }

  Future<void> _fetchPokemonDetails() async {
    try {
      final dio = Dio();
      final response = await dio.get(urlPokemon);
      setState(() {
        detalhesPokemon = response.data;
        List<dynamic> types = detalhesPokemon['types'] ?? [];
        backgroundColor = _getBackgroundColor(types);
        isLoading = false;
        pesoEmQuilos = detalhesPokemon["weight"] / 10;
        alturaEmMetros = detalhesPokemon["height"] / 10;
      });
    } catch (e) {
      print("Erro ao buscar detalhes do Pokémon: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _goToEvolutionChain(RightLeftEnum rightLeftEnum) async {
    final dio = Dio();
    final species = await dio.get(detalhesPokemon["species"]["url"]);

    if (rightLeftEnum == RightLeftEnum.left) {
      if (species.data["evolves_from_species"] == null) return;
      final previousSpecie =
          await dio.get(species.data["evolves_from_species"]["url"]);
      var previousPokemonSumurryData =
          (previousSpecie.data["varieties"] as List<dynamic>)
              .firstWhere((e) => e["is_default"] == true);
      urlPokemon = previousPokemonSumurryData["pokemon"]["url"];
      isLoading = true;
      _fetchPokemonDetails();
    } else {
      var pokemonId = detalhesPokemon["id"];
      var evolvesChain = await dio.get(species.data["evolution_chain"]["url"]);
      var chain = evolvesChain.data["chain"];
      if ((chain["evolves_to"] as List<dynamic>).length == 1) {
        var shouldContinue = true;
        while (shouldContinue) {
          if (chain["evolves_to"].isEmpty ||
              chain["evolves_to"][0]["species"]["url"] == null) {
            shouldContinue = false;
            continue;
          }
          if (chain["evolves_to"][0]["species"]["url"] ==
              "https://pokeapi.co/api/v2/pokemon-species/${pokemonId + 1}/") {
            final nextSpecie =
                await dio.get(chain["evolves_to"][0]["species"]["url"]);
            var previousPokemonSumurryData =
                (nextSpecie.data["varieties"] as List<dynamic>)
                    .firstWhere((e) => e["is_default"] == true);
            urlPokemon = previousPokemonSumurryData["pokemon"]["url"];
            shouldContinue = false;
            isLoading = true;
            _fetchPokemonDetails();
          } else {
            chain = chain["evolves_to"][0];
          }
        }
      } else {
        for (var item in chain["evolves_to"]) {
          if (item["species"]["url"] ==
              "https://pokeapi.co/api/v2/pokemon-species/${pokemonId + 1}/") {
            final nextSpecie = await dio.get(item["species"]["url"]);
            var previousPokemonSumurryData =
                (nextSpecie.data["varieties"] as List<dynamic>)
                    .firstWhere((e) => e["is_default"] == true);
            urlPokemon = previousPokemonSumurryData["pokemon"]["url"];
            _fetchPokemonDetails();
          }
        }
      }
    }
  }

  Color _getBackgroundColor(List<dynamic> types) {
    if (types.isEmpty) return Colors.grey;
    switch (types[0]['type']['name']) {
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
        return const Color.fromARGB(255, 99, 40, 7);
      case 'ice':
        return const Color.fromARGB(255, 7, 212, 202);
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String types) {
    if (types.isEmpty) return const Color.fromARGB(255, 247, 246, 246);
    switch (types) {
      case 'grass':
        return const Color.fromARGB(255, 6, 139, 10);
      case 'fire':
        return const Color.fromARGB(255, 138, 41, 3);
      case 'water':
        return const Color.fromARGB(255, 5, 61, 107);
      case 'electric':
        return const Color.fromARGB(255, 90, 68, 4);
      case 'poison':
        return const Color.fromARGB(255, 85, 3, 102);
      case 'bug':
        return const Color.fromARGB(255, 63, 114, 5);
      case 'flying':
        return const Color.fromARGB(255, 9, 100, 143);
      case 'normal':
        return const Color.fromARGB(255, 104, 102, 102);
      case 'fighting':
        return const Color.fromARGB(255, 102, 3, 3);
      case 'rock':
        return const Color.fromARGB(255, 150, 47, 10);
      case 'psychic':
        return const Color.fromARGB(255, 84, 41, 160);
      case 'fairy':
        return const Color.fromARGB(255, 173, 24, 129);
      case 'ghost':
        return const Color.fromARGB(255, 52, 5, 114);
      case 'ground':
        return const Color.fromARGB(255, 68, 26, 3);
      case 'ice':
        return const Color.fromARGB(255, 6, 131, 125);
      default:
        return const Color.fromARGB(255, 83, 80, 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getBackgroundColor(detalhesPokemon['types'] ?? []),
        title: Text(
          widget.nome,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${detalhesPokemon['name']}'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 36,
                      onPressed: () {
                        _goToEvolutionChain(RightLeftEnum.left);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...detalhesPokemon["types"].map((type) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: _getTypeColor(type["type"]["name"]),
                              ),
                              child: Text(
                                type["type"]["name"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      iconSize: 36,
                      onPressed: () {
                        _goToEvolutionChain(RightLeftEnum.right);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Image.network(
                        detalhesPokemon['sprites']['front_default']
                            .replaceAll('small', 'large'),
                        fit: BoxFit.cover,
                        height: 160,
                        width: 160,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.12),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Movimentos do Pokémon'),
                                  content: SingleChildScrollView(
                                    // trocar para Wrap

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...detalhesPokemon['moves']
                                            .map<Widget>((move) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              move['move']['name'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Fechar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 248, 248, 248),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(Icons.sports_martial_arts)),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Height',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${alturaEmMetros} m',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Weight',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${pesoEmQuilos} kg',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Abilities',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    detalhesPokemon['abilities']
                                        .map((ability) =>
                                            ability["ability"]['name'])
                                        .toList()
                                        .join(", "),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(238, 238, 238, 1),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estatísticas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 5, 5, 5),
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildStatRow("HP",
                                  detalhesPokemon["stats"][0]["base_stat"]),
                              _buildStatRow("Ataque",
                                  detalhesPokemon["stats"][1]["base_stat"]),
                              _buildStatRow("Defesa",
                                  detalhesPokemon["stats"][2]["base_stat"]),
                              _buildStatRow("Atk Special",
                                  detalhesPokemon["stats"][3]["base_stat"]),
                              _buildStatRow("Def Special",
                                  detalhesPokemon["stats"][4]["base_stat"]),
                              _buildStatRow("Velocidade",
                                  detalhesPokemon["stats"][5]["base_stat"]),
                            ],
                          ),
                        ),
                        SizedBox(height: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCardRow(List<Map<String, String>> items) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        color: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item['value']!,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    IconData icon;

    switch (label) {
      case "HP":
        icon = Icons.favorite;
        break;
      case "Ataque":
        icon = Icons.flash_on;
        break;
      case "Defesa":
        icon = Icons.shield;
        break;
      case "Atk Special":
        icon = Icons.local_fire_department;
        break;
      case "Def Special":
        icon = Icons.security;
        break;
      case "Velocidade":
        icon = Icons.directions_run;
        break;
      default:
        icon = Icons.help;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _getColorForStat(value)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 2, 2, 2),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getColorForStat(value)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 14, 14, 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForStat(int value) {
    if (value >= 80) {
      return Colors.green;
    } else if (value >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

Widget _buildInfoCard(String label, String value) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Card(
      color: const Color.fromRGBO(238, 238, 238, 1),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStatRow(String label, int value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 2, 2, 2),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            valueColor: AlwaysStoppedAnimation<Color>(_getColorForStat(value)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 14, 14, 14),
          ),
        ),
      ],
    ),
  );
}

Color _getColorForStat(int value) {
  if (value >= 80) {
    return Colors.green;
  } else if (value >= 50) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
