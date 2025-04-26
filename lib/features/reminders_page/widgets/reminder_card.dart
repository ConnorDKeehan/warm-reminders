import 'package:flutter/material.dart';
import 'package:warmreminders/features/reminders_page/widgets/delete_reminder_button.dart';
import 'package:warmreminders/features/reminders_page/widgets/edit_reminder_button.dart';
import 'package:warmreminders/models/entities/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback resyncMainPage;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.resyncMainPage,
  });

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context).colorScheme;

    final shadowDarkness = colourScheme.brightness == Brightness.dark ? 0.9 : 0.3;
    final reminderDate = reminder.dateCreatedUtc.toLocal().toString().split(' ')[0];

    var title = '$reminderDate - ${reminder.category} - ${'★' * reminder.importance}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: colourScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(shadowDarkness),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: EditReminderButton(
                    reminderId: reminder.id,
                    onUpdate: resyncMainPage,
                    initialText: reminder.reminderText,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: DeleteReminderButton(
                    id: reminder.id,
                    onUpdate: resyncMainPage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              reminder.reminderText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
