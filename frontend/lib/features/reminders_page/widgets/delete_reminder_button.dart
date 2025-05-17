import 'package:flutter/material.dart';
import 'package:warmreminders/features/reminders_page/reminders_page_api.dart';

class DeleteReminderButton extends StatefulWidget {
  final VoidCallback onUpdate;
  final int id;

  const DeleteReminderButton({
    super.key,
    required this.onUpdate,
    required this.id
  });

  @override
  State<DeleteReminderButton> createState() => _DeleteReminderButtonState();
}

class _DeleteReminderButtonState extends State<DeleteReminderButton> {
  void _deleteReminder() async {
    await deleteReminder(widget.id);
    widget.onUpdate();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => _DeleteGratitudeDialog(onDelete: _deleteReminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      iconSize: 16,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(20,20)),
      icon: Icon(Icons.close, color: theme.hintColor),
      onPressed: _showDialog
    );
  }
}

class _DeleteGratitudeDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteGratitudeDialog({
    super.key,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Delete Reminder'),
      content: const Text('Are you sure you want to delete this entry?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.focusColor,
          ),
          child: const Text('DELETE'),
        ),
      ],
    );
  }
}
