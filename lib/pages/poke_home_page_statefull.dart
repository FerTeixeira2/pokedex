import 'package:flutter/material.dart';

class PokeHomePageStatefull extends StatefulWidget {
  const PokeHomePageStatefull({super.key});

  @override
  State<PokeHomePageStatefull> createState() => _PokeHomePageStatefull();
}

class _PokeHomePageStatefull extends State<PokeHomePageStatefull> {
  bool isCarregado = true;
  List<String> listaDePokemon = [];

  @override
  void initState() {
    super.initState();
    _carregadoDados();
  }

  Future<void> _carregadoDados() async {
    await Future.delayed(Duration(seconds: 4));
    listaDePokemon = ["Charmander", "Bubasauro", "Pikachu", "Snorlaks"];
    isCarregado = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pokemons"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return isCarregado
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: listaDePokemon.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listaDePokemon[index]),
              );
            },
          );
  }
}
