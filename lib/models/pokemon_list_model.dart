class PokemonListModel {
  final int count;
  final String next;
  final String previuos;
  final List<dynamic> result;

  PokemonListModel({
    required this.count,
    required this.next,
    required this.previuos,
    required this.result,
  });

  factory PokemonListModel.fromMap(Map<String, dynamic> map) {
    return PokemonListModel(
      count: map["count"] as int,
      next: map["next"] as String,
      previuos: map["previus"] as String,
      result: map["result"] as List<dynamic>,
    );
  }
}
