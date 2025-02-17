class ListPokemomModel {
  final String nome;
  final String url;

  ListPokemomModel({
    required this.nome,
    required this.url,
  });

  factory ListPokemomModel.fromMap(Map<String, dynamic> map) {
    return ListPokemomModel(
      nome: map['name'],
      url: map['url'],
    );
  }
}
