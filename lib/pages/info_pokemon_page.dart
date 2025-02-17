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
        title: Text(widget.nome),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 158, 245, 212),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          detalhesPokemon['sprites']['front_default'] ?? '',
                          height: 130,
                          width: 130,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text('Name: ${widget.nome}',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold)),
                      SizedBox(height: 14),
                      Text('ID: ${detalhesPokemon['id']}',
                          style: TextStyle(fontSize: 27)),
                      Text('Height: ${detalhesPokemon['height']} decímetros',
                          style: TextStyle(fontSize: 27)),
                      Text('Weight: ${detalhesPokemon['weight']} hectogramas',
                          style: TextStyle(fontSize: 27)),
                      Text(
                          'Base Experience: ${detalhesPokemon['base_experience']}',
                          style: TextStyle(fontSize: 27)),
                      SizedBox(height: 14),
                      Text('Abilities:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ...detalhesPokemon['abilities']
                          .map<Widget>((ability) => Text(
                              ability['ability']['name'],
                              style: TextStyle(fontSize: 27)))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
