import 'package:flutter/material.dart';
import 'package:warmreminders/utils/storage_util.dart';
import 'package:warmreminders/widgets/action_pill/action_pill.dart';

class CategoryPill extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;
  const CategoryPill({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  static const _addNewKey = '__ADD_NEW__';

  @override
  State<CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<CategoryPill> {
  String selectedCategory = usersCategories.first;

  void _handleSelectCategory(String category) {
    if (!usersCategories.contains(category)) {
      usersCategories.add(category);
    }
    setState(() => selectedCategory = category);
    widget.onCategorySelected(category);
  }

  Future<void> _showCategoryDialog() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Category'),
        children: [
          ...usersCategories.map((category) => SimpleDialogOption(
            child: Text(category),
            onPressed: () => Navigator.pop(ctx, category),
          )),
          const Divider(),
          SimpleDialogOption(
            onPressed: () =>
                Navigator.pop(ctx, CategoryPill._addNewKey),
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
        _handleSelectCategory(newCat.trim());
      }
    } else if (choice != selectedCategory) {
      _handleSelectCategory(choice);
    }
  }

  Future<String?> _promptNewCategory(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New category name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. “Groceries”'),
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionPill(
      icon: Icons.label_outline,
      label: selectedCategory,
      selected: true,
      onTap: _showCategoryDialog,
    );
  }
}
