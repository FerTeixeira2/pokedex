import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetails();
  }

  Future<void> _fetchPokemonDetails() async {
    try {
      final dio = Dio();
      final response = await dio.get(widget.url);
      setState(() {
        detalhesPokemon = response.data;
        List<dynamic> types = detalhesPokemon['types'] ?? [];
        backgroundColor = _getBackgroundColor(types);
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao buscar detalhes do Pokémon: $e");
      setState(() {
        isLoading = false;
      });
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
      default:
        return Colors.grey;
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${detalhesPokemon['name']}'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Arial",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'ID # ${detalhesPokemon['id']}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Image.network(
                      detalhesPokemon['sprites']['front_default']
                          .replaceAll('small', 'large'),
                      fit: BoxFit.cover,
                      height: 160,
                      width: 160,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                        _buildInfoCard(
                            'Height', '${detalhesPokemon['height']} dm'),
                        _buildInfoCard(
                            'Weight', '${detalhesPokemon['weight']} hg'),
                        _buildInfoCard('Base Experience',
                            '${detalhesPokemon['base_experience']}'),
                        SizedBox(height: 16),
                        _buildInfoCard(
                            'Abilities:',
                            detalhesPokemon['abilities']
                                .map<Widget>((ability) {
                                  return Text(
                                    ability['ability']['name'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  );
                                })
                                .toList()
                                .join(", ")),
                        SizedBox(height: 16),
                        _buildInfoCard('Type',
                            '${detalhesPokemon["types"][0]["type"]["name"]}'),
                        SizedBox(height: 16),
                        _buildInfoCard('Moves:',
                            '${detalhesPokemon["moves"][0]["move"]["name"]}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: Colors.grey[200],
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
}
