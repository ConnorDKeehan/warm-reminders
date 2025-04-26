import 'package:flutter/material.dart';
import 'package:warmreminders/utils/storage_util.dart';

class CategoryPill extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;

  const CategoryPill({
    super.key,
    required this.onCategorySelected,
  });

  static const _addNewKey = '__ADD_NEW__';

  @override
  State<CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<CategoryPill> {
  String selectedCategory = usersCategories.first;

  void handleSelectCategory(String selected){
    usersCategories.add(selected);

    setState(() {
      selectedCategory = selected;
    });

    widget.onCategorySelected(selected);
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        final choice = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Category'),
            children: [
              ...usersCategories.map((category) {
                return SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, category),
                  child: Text(category),
                );
              }).toList(),
              const Divider(),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, CategoryPill._addNewKey),
                child: Row(
                  children: const [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('Add new category'),
                  ],
                ),
              ),
            ],
          ),
        );

        if (choice == null) return;
        if (choice == CategoryPill._addNewKey) {
          final newCat = await _promptNewCategory(context);
          if (newCat != null && newCat.trim().isNotEmpty) {
            final trimmed = newCat.trim();

            handleSelectCategory(trimmed);
          }
        } else if (choice != selectedCategory) {
          handleSelectCategory(choice);
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
            onDeleted: () {},
          ),
        ],
      ),
    );
  }

  Future<String?> _promptNewCategory(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New category name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. “Groceries”'),
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
