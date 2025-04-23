import 'package:flutter/material.dart';
import 'package:warmreminders/features/main_page/main_page_api.dart';
import 'package:warmreminders/features/main_page/models/requests/post_reminder_request.dart';

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
  final TextEditingController _controller = TextEditingController();

  _AddReminderDialog({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 300,
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
              TextField(
                controller: _controller,
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
                maxLines: 3,
              ),
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
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        onAdd(PostReminderRequest(reminderText: text, category: 'Reminder'));
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
    );
  }
}
