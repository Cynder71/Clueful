class Outfit {
  final String id;
  final String name;
  final List<String> itemIds;

  Outfit({required this.id, required this.name, required this.itemIds});

  factory Outfit.fromMap(Map<String, dynamic> map, String id) {
    return Outfit(
      id: id,
      name: map['name'],
      itemIds: List<String>.from(map['itemIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemIds': itemIds,
    };
  }
}
