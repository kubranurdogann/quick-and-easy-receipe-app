import 'package:flutter/material.dart';
import '../models/meal.dart';

class FavoritesPage extends StatelessWidget {
  final List<Meal> favoriteMeals;
  final void Function(Meal) onRemove;
  final void Function(Meal) onSelectMeal;

  const FavoritesPage({
    super.key,
    required this.favoriteMeals,
    required this.onRemove,
    required this.onSelectMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Favorites")),
        backgroundColor: const Color(0xffe7f1f7),
      ),
      backgroundColor: Colors.white, // ← ARKA PLAN BURADA

      body: favoriteMeals.isEmpty
          ? const Center(
              child: Text(
                "Henüz favoriniz yok.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favoriteMeals[index];
                return ListTile(
                  leading: Image.network(
                    meal.thumbnail,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(meal.name),
                  subtitle: Text("${meal.calories} kcal · ${meal.duration} dk"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onRemove(meal),
                  ),
                  onTap: () => onSelectMeal(meal),
                );
              },
            ),
    );
  }
}
