class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final int calories;
  final int duration;
  bool isFavorite; // ✔ Tek tane bırakıldı
  List<Map<String, String>> ingredients;
  String instructions;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.calories,
    required this.duration,
    this.isFavorite = false,
    this.ingredients = const [],
    this.instructions = "",
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final randomCalories = 200 + (json['idMeal'].hashCode % 300);
    final randomDuration = 10 + (json['idMeal'].hashCode % 50);

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      calories: randomCalories,
      duration: randomDuration,
    );
  }

  // ✔ Favori kontrolünün düzgün çalışması için eşitlik operatörü
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal && runtimeType == other.runtimeType && id == other.id;

  // ✔ HashCode eklenmeli
  @override
  int get hashCode => id.hashCode;
}
