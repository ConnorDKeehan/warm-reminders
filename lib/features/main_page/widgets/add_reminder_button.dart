import 'package:flutter/material.dart';
import 'package:warmreminders/features/main_page/main_page_api.dart';
import 'package:warmreminders/features/main_page/models/requests/post_reminder_request.dart';
import 'package:warmreminders/features/main_page/widgets/category_pill.dart';
import 'package:warmreminders/features/main_page/widgets/importance_pill.dart';
import 'package:warmreminders/utils/storage_util.dart';

class AddReminderButton extends StatefulWidget {
  final VoidCallback onAdd;

  const AddReminderButton({super.key, required this.onAdd});

  @override
  State<AddReminderButton> createState() => _AddReminderButtonState();
}

class _AddReminderButtonState extends State<AddReminderButton> {

  void addReminder(PostReminderRequest request){
    postReminder(request);
    widget.onAdd();
  }

  void _showDialog() {
    final String defaultCategory = usersCategories.firstOrNull ?? "Reminder";
    showDialog(
      context: context,
      builder: (context) => _AddReminderDialog(onAdd: addReminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _showDialog,
      icon: const Icon(Icons.favorite),
      label: const Text("Add Reminder"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).splashColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _AddReminderDialog extends StatelessWidget {
  final Function(PostReminderRequest) onAdd;
  final TextEditingController _reminderController = TextEditingController();

  _AddReminderDialog({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    String selectedCategory = usersCategories.first;
    int selectedImportance = 3;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: IntrinsicHeight(child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary, size: 40),
              const Text(
                'Add Warm Reminder',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _reminderController,
                decoration: InputDecoration(
                  hintText: 'What would you like to be warmly reminded of?',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                minLines: 3,
                maxLines: 10,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final text = _reminderController.text.trim();
                      final category = selectedCategory;
                      if (text.isNotEmpty) {
                        onAdd(PostReminderRequest(
                            reminderText: text,
                            category: category.isNotEmpty ? category : 'Reminder'
                        ));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
