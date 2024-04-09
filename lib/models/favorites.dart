class Favorite {
  final int id;
  final String name;
  final String sinopse;
  final String img;

  Favorite(
      {required this.id,
      required this.name,
      required this.sinopse,
      required this.img});

  Favorite.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        sinopse = item["sinopse"],
        img = item["img"];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, 'sinopse': sinopse, 'img': img};
  }
}
