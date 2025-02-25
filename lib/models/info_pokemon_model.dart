class CaractePokemonModel {
  final String name;
  final int height;
  final int weight;
  final List<dynamic> types;
  final List<dynamic> moves;
  final List<dynamic> abilities;
  final List<dynamic> stats;

  CaractePokemonModel(
      {required this.name,
      required this.height,
      required this.weight,
      required this.types,
      required this.moves,
      required this.abilities,
      required this.stats});

  factory CaractePokemonModel.InfoPokeModel(Map<String, dynamic> json) {
    return CaractePokemonModel(
        name: json["name"] as String,
        height: json["height"] as int,
        weight: json["weight"] as int,
        types: json["type"] as List<dynamic>,
        moves: json["moves"] as List<dynamic>,
        abilities: json["abilities"] as List<dynamic>,
        stats: json["stats"] as List<dynamic>);
  }
}
