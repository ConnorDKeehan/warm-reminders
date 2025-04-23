import 'package:flutter/material.dart';
import 'package:warmreminders/features/schedules_page/models/requests/patch_schedule_request.dart';
import 'package:warmreminders/features/schedules_page/schedules_page_api.dart';
import 'package:warmreminders/models/entities/schedule.dart';

class EditScheduleButton extends StatefulWidget {
  final VoidCallback onUpdate;
  final Schedule schedule;

  const EditScheduleButton({
    super.key,
    required this.onUpdate,
    required this.schedule
  });

  @override
  State<EditScheduleButton> createState() => _EditScheduleButtonState();
}

class _EditScheduleButtonState extends State<EditScheduleButton> {
  Future<void> _editSchedule(DateTime newUtcTime) async {
    // intervalHours is fixed at 24 for daily schedules
    await patchSchedule(
      widget.schedule.id,
      PatchScheduleRequest(
        nextNotificationTimeUtc: newUtcTime,
        intervalHours: 24,
      ),
    );
    widget.onUpdate();
  }

  void _showTimePicker() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        widget.schedule.nextNotificationTimeUtc.toLocal(),
      ),
      helpText: 'Select new notification time',
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      // Build a DateTime today with the selected clock time
      var scheduledLocal = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      // Convert to UTC
      var scheduledUtc = scheduledLocal.toUtc();
      // If that time today has already passed in UTC, schedule for tomorrow
      if (DateTime.now().toUtc().isAfter(scheduledUtc)) {
        scheduledUtc = scheduledUtc.add(const Duration(days: 1));
      }

      await _editSchedule(scheduledUtc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context);
    return IconButton(
      iconSize: 16,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(20, 20)),
      icon: Icon(Icons.edit, color: colourScheme.hintColor),
      onPressed: _showTimePicker,
    );
  }
}
