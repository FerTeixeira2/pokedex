class CaractePokemonModel {
  final String name;
  final int height;
  final int weight;
  final List<dynamic> types;
  final List<dynamic> moves;
  final List<dynamic> abilities;

  CaractePokemonModel({
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.moves,
    required this.abilities,
  });

  factory CaractePokemonModel.InfoPokeModel(Map<String, dynamic> json) {
    return CaractePokemonModel(
      name: json["name"] as String,
      height: json["height"] as int,
      weight: json["weight"] as int,
      types: json["type"] as List<dynamic>,
      moves: json["moves"] as List<dynamic>,
      abilities: json["abilities"] as List<dynamic>,
    );
  }
}
