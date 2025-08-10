import 'package:flutter/material.dart';

class CategoryFilters extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final List<String> categories;
  const CategoryFilters({
    super.key,
    required this.onCategorySelected,
    this.selectedCategory,
    this.categories = const [],
  });

  @override
  Widget build(BuildContext context) {
    // 📸 Sights & Museums (interesting_places, museums)

    // 🕌 Religion (mosques, temples)

    // 🌳 Parks & Nature (natural)

    // 🍽️ Food (foods, restaurants)

    // 🛍️ Shopping

    // 🎭 Culture (cultural)

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;
        return buildCategoryFilterItem(category, context, isSelected);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
    );
  }

  Widget buildCategoryFilterItem(
    String category,
    BuildContext context,
    bool isSelected,
  ) {
    return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.transparent : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        child: TextButton(
          onPressed: () {
            onCategorySelected(category);
          },
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : Colors.black,
            ),
          ),
        ),
      
    );
  }
}
