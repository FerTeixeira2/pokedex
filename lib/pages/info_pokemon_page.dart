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
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao buscar detalhes do Pokémon: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.nome, style: TextStyle(fontSize: 24)),
      ),
      backgroundColor: const Color.fromARGB(255, 149, 206, 233),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${detalhesPokemon['name']}'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 44, 33, 33),
                        fontFamily: "arial"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'ID # ${detalhesPokemon['id']}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Image.network(
                    detalhesPokemon['sprites']['front_default']
                        .replaceAll('small', 'large'),
                    fit: BoxFit.cover,
                    height: 230,
                    width: 230,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 83, 60, 60),
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${detalhesPokemon['id']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Height: ${detalhesPokemon['height']} decímetros',
                            style: TextStyle(fontSize: 16)),
                        Text('Weight: ${detalhesPokemon['weight']} hectogramas',
                            style: TextStyle(fontSize: 16)),
                        Text(
                            'Base Experience: ${detalhesPokemon['base_experience']}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 20),
                        Text('Abilities:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        ...detalhesPokemon['abilities']
                            .map<Widget>((ability) => Text(
                                ability['ability']['name'],
                                style: TextStyle(fontSize: 16)))
                            .toList(),
                        SizedBox(height: 20),
                        Text('Type:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                            'Type: ${detalhesPokemon["types"][0]["type"]["name"]}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 20),
                        Text('Moves:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                            'Moves: ${detalhesPokemon["moves"][0]["move"]["name"]}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
