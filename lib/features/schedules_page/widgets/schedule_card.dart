import 'package:flutter/material.dart';
import 'package:warmreminders/features/schedules_page/widgets/delete_schedule_button.dart';
import 'package:warmreminders/features/schedules_page/widgets/edit_schedule_button.dart';
import 'package:warmreminders/models/entities/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback resyncMainPage;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.resyncMainPage,
  });

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context).colorScheme;
    final shadowDarkness =
    colourScheme.brightness == Brightness.dark ? 0.9 : 0.3;

    final timeString = TimeOfDay.fromDateTime(
      schedule.nextNotificationTimeUtc.toLocal(),
    ).format(context);

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
        child: Row(
          children: [
            // Notification time
            Text(
              timeString,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),

            // Edit button
            SizedBox(
              height: 20,
              width: 20,
              child: EditScheduleButton(
                schedule: schedule,
                onUpdate: resyncMainPage,
              ),
            ),
            const SizedBox(width: 8),

            // Delete button
            SizedBox(
              height: 20,
              width: 20,
              child: DeleteScheduleButton(
                id: schedule.id,
                onUpdate: resyncMainPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
