import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealService {
  Future<List<Meal>> fetchMeals() async {
    final url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'];

      if (meals != null) {
        return List<Meal>.from(meals.map((m) => Meal.fromJson(m)));
      } else {
        return [];
      }
    } else {
      throw Exception('Veri alınamadı');
    }
  }
}
