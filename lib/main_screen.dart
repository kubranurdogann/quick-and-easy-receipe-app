import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'models/meal.dart';
import 'chat_screen.dart';
import 'meal_detail_page.dart'; // Detay sayfasını da import edelim

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Meal> favoriteMeals = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔹 Favori ekleme / çıkarma
  void toggleFavorite(Meal meal) {
    setState(() {
      if (favoriteMeals.contains(meal)) {
        favoriteMeals.remove(meal);
        meal.isFavorite = false;

        // ❌ SnackBar: Favoriden kaldırıldı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.favorite_border, color: Colors.white),
                SizedBox(width: 8),
                Text("Favorilerden kaldırıldı"),
              ],
            ),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        favoriteMeals.add(meal);
        meal.isFavorite = true;

        // ❤️ SnackBar: Favoriye eklendi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 8),
                Text("Favorilere eklendi"),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // 🔹 Favorilerden silme (sadece kaldırma)
  void removeFromFavorites(Meal meal) {
    setState(() {
      favoriteMeals.remove(meal);
      meal.isFavorite = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Text("Favorilerden kaldırıldı"),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onToggleFavorite: toggleFavorite, favoriteMeals: favoriteMeals),
      FavoritesPage(
        favoriteMeals: favoriteMeals,
        onRemove: removeFromFavorites,
        onSelectMeal: (meal) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealDetailPage(
                meal: meal,
                onToggleFavorite: toggleFavorite,
              ),
            ),
          );
        },
      ),
      const ChatPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.blue,
              size: 24.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.pink,
              size: 24.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.green,
              size: 24.0,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
