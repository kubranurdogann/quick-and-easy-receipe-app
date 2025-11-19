import 'package:flutter/material.dart';
import 'package:helloworld/welcome_screen.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import 'meal_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onToggleFavorite,
    required this.favoriteMeals,
  });

  final Function(Meal) onToggleFavorite;
  final List<Meal> favoriteMeals;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MealService _mealService = MealService();
  List<Meal> meals = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    try {
      final data = await _mealService.fetchMeals();

      setState(() {
        meals = data.map((meal) {
          meal.isFavorite = widget.favoriteMeals.contains(meal);
          return meal;
        }).toList();
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openMealDetail(Meal meal) async {
    final updatedMeal = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MealDetailPage(
                meal: meal,
                onToggleFavorite: widget.onToggleFavorite,
              )),
    );

    if (updatedMeal != null) {
      widget.onToggleFavorite(updatedMeal);

      setState(() {
        final index = meals.indexWhere((m) => m.id == updatedMeal.id);
        if (index != -1) {
          meals[index].isFavorite = updatedMeal.isFavorite;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFE6EEF3),
          appBar: AppBar(
            title: const Center(child: Text("Quick&Easy")),
            backgroundColor: const Color(0xffe7f1f7),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isError
                    ? const Center(child: Text("Veri alınırken hata oluştu"))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          final meal = meals[index];

                          return GestureDetector(
                            onTap: () => openMealDetail(meal),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          meal.thumbnail,
                                          width: double.infinity,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              meal.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: meal.isFavorite
                                                  ? Colors.red
                                                  : Colors.grey[700],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                meal.isFavorite =
                                                    !meal.isFavorite;
                                              });
                                              widget.onToggleFavorite(meal);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          meal.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_fire_department,
                                              color: Colors.redAccent,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${meal.calories} kcal",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.timer,
                                              color: Colors.blueAccent,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${meal.duration} dk",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Henüz bir bildirimin yok 😊')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
