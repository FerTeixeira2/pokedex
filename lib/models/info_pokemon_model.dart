class CaractePokemonModel {
  final String name;
  final int height;
  final int weight;
  final List<dynamic> abilities;

  CaractePokemonModel({
    required this.name,
    required this.height,
    required this.weight,
    required this.abilities,
  });

  factory CaractePokemonModel.InfoPokeModel(Map<String, dynamic> json) {
    return CaractePokemonModel(
      name: json["name"] as String,
      height: json["height"] as int,
      weight: json["weight"] as int,
      abilities: json["abilities"] as List<dynamic>,
    );
  }
}
