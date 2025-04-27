import 'package:flutter/material.dart';
import 'package:warmreminders/features/reminders_page/models/requests/post_reminder_request.dart';
import 'package:warmreminders/features/reminders_page/reminders_page_api.dart';
import 'package:warmreminders/features/reminders_page/widgets/category_pill.dart';
import 'package:warmreminders/features/reminders_page/widgets/importance_pill.dart';
import 'package:warmreminders/styles/app_colors.dart';
import 'package:warmreminders/styles/app_styles.dart';
import 'package:warmreminders/utils/storage_util.dart';
import 'package:warmreminders/widgets/add_item_button/add_item_button.dart';

class AddReminderButton extends StatefulWidget {
  final VoidCallback onAdded;
  const AddReminderButton({super.key, required this.onAdded});

  @override
  State<AddReminderButton> createState() => _AddReminderButtonState();
}

class _AddReminderButtonState extends State<AddReminderButton> {
  final _controller = TextEditingController();
  String selectedCategory = usersCategories.first;
  int selectedImportance = 3;

  void handleAdd() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final request = PostReminderRequest(
      reminderText: text,
      category: selectedCategory,
      importance: selectedImportance,
    );
    await postReminder(request);

    widget.onAdded();

    _controller.clear();
    selectedCategory = usersCategories.first;
    selectedImportance = 3;

    Navigator.of(context).pop();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,      // let it grow above the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'What would you like to be reminded of?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                CategoryPill(
                  onCategorySelected: (category) {
                    selectedCategory = category;
                  },
                ),
                ImportancePill(
                    onLevelSelected: (newLevel) {
                      selectedImportance = newLevel;
                    }
                )
              ],
            ),
            const SizedBox(height: 16),

            // add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleAdd,
                style: AppStyles.submitButtonStyle,
                child: const Text('Add')
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddItemButton(onPressed: _showBottomSheet);
  }
}


