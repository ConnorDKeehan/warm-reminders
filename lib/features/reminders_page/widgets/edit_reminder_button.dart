import 'package:flutter/material.dart';
import 'package:warmreminders/features/reminders_page/models/requests/patch_reminder_request.dart';
import 'package:warmreminders/features/reminders_page/reminders_page_api.dart';
import 'package:warmreminders/styles/app_styles.dart';

class EditReminderButton extends StatefulWidget {
  final VoidCallback onUpdate;
  final int reminderId;
  final String initialText;

  const EditReminderButton({
    super.key,
    required this.onUpdate,
    required this.initialText,
    required this.reminderId}
  );

  @override
  State<EditReminderButton> createState() => _AddReminderButtonState();
}

class _AddReminderButtonState extends State<EditReminderButton> {

  void editReminder(String request) async{
    await updateReminder(widget.reminderId, PatchReminderRequest(reminderText: request, category: "Reminder"));
    widget.onUpdate();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => _EditGratitudeDialog(onUpdate: editReminder, initialText: widget.initialText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context);
    return IconButton(
      iconSize: 16,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(20,20)),
      icon: Icon(Icons.edit, color: colourScheme.hintColor),
      onPressed: _showDialog,
    );
  }
}

class _EditGratitudeDialog extends StatelessWidget {
  final Function(String) onUpdate;
  final TextEditingController _controller;

  _EditGratitudeDialog({
    super.key,
    required this.onUpdate,
    required String initialText,
  })  : _controller = TextEditingController(text: initialText);

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
              Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 40),
              const Text(
                'Edit Reminder',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Update your reminder',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
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
                        onUpdate(text);
                        Navigator.pop(context);
                      }
                    },
                    style: AppStyles.submitButtonStyle,
                    child: const Text('Save'),
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
