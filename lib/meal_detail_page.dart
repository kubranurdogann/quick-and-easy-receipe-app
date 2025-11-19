import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  final Function(Meal) onToggleFavorite;

  const MealDetailPage({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
  });

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  int servings = 1;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  String scaleMeasure(String measure) {
    // Ölçü boşsa direkt döndür
    if (measure.trim().isEmpty) return measure;

    // Ölçüdeki ilk sayı değerini bul (ör: "200g" → 200)
    final regex = RegExp(r"([0-9]+(?:\.[0-9]+)?)");
    final match = regex.firstMatch(measure);

    if (match == null) return measure; // Sayı yoksa direkt döndür

    double value = double.tryParse(match.group(0)!) ?? 1;
    double scaledValue = value * servings;

    // Sayıyı yeni değer ile değiştir
    return measure.replaceFirst(
        match.group(0)!, scaledValue.toStringAsFixed(0));
  }

  Future<void> fetchMealDetail() async {
    final res = await http.get(Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.meal.id}"));

    final data = json.decode(res.body)['meals'][0];

    List<Map<String, String>> ingredientList = [];

    for (int i = 1; i <= 20; i++) {
      final ing = data["strIngredient$i"];
      final measure = data["strMeasure$i"];

      if (ing != null && ing.isNotEmpty) {
        ingredientList.add({"ingredient": ing, "measure": measure ?? ""});
      }
    }

    setState(() {
      widget.meal.ingredients = ingredientList;
      widget.meal.instructions = data["strInstructions"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Image.network(widget.meal.thumbnail, fit: BoxFit.cover),
          ),

          /// BACK + FAVORITE BUTTONS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildCircleButton(
                    icon: widget.meal.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onTap: () {
                      setState(() {
                        widget.meal.isFavorite = !widget.meal.isFavorite;
                      });

                      widget.onToggleFavorite(
                          widget.meal); // 🔥 ANASAYFAYA HABER VER
                    },
                  ),
                ],
              ),
            ),
          ),

          /// SCROLL CONTENT
          DraggableScrollableSheet(
            initialChildSize: 0.62,
            maxChildSize: 0.95,
            minChildSize: 0.55,
            builder: (context, scrollController) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// MEAL NAME
                    Text(widget.meal.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

// INGREDIENTS HEADER + SERVING CONTROLS ALIGNED HORIZONTALLY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        // Servings Controls
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (servings > 1) setState(() => servings--);
                              },
                              child: _buildCountButton(Icons.remove),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "$servings",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => servings++),
                              child: _buildCountButton(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "How many servings?",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    // INGREDIENT LIST
                    widget.meal.ingredients.isEmpty
                        ? const Text("Loading ingredients...",
                            style: TextStyle(color: Colors.grey))
                        : Column(
                            children: widget.meal.ingredients.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Ingredient Name
                                    Text(
                                      item["ingredient"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),

                                    // Scaled Measure (depends on servings)
                                    Text(
                                      scaleMeasure(item["measure"] ?? ""),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 24),

                    const Text("Preparation",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.meal.instructions,
                        style: const TextStyle(height: 1.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _buildCountButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Icon(icon, size: 18),
    );
  }
}
