import 'package:flutter/material.dart';

class CategoryPillSelector extends StatelessWidget {
  final String selectedCategory;
  final List<String> availableCategories;
  final ValueChanged<String> onCategorySelected;

  const CategoryPillSelector({
    super.key,
    required this.selectedCategory,
    required this.availableCategories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final newCategory = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('Select Category'),
                children: availableCategories.map((category) {
                  return SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, category),
                    child: Text(category),
                  );
                }).toList(),
              ),
            );
            if (newCategory != null && newCategory != selectedCategory) {
              onCategorySelected(newCategory);
            }
          },
          child: Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(
                  selectedCategory,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                deleteIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                onDeleted: () {}, // purely for dropdown icon display
              ),
            ],
          ),
        ),
      ],
    );
  }
}
