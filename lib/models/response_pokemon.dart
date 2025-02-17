class ResponsePokemomList {
  final int count;
  final String next;
  final String previous;
  final dynamic result;

  ResponsePokemomList(
      {required this.count,
      required this.next,
      required this.previous,
      required this.result});

  factory ResponsePokemomList.fromMap(Map<String, dynamic> map) {
    return ResponsePokemomList(
      count: map["count"] as int,
      next: map["next"] as String,
      previous: map["previous"] as String,
      result: map["result"] as List<dynamic>,
    );
  }
}
