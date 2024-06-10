class Item {
  final String id;
  final String name;
  final String imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.imageUrl
  });

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl
    };
  }
}