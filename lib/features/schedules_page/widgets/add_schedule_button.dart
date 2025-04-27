import 'package:flutter/material.dart';
import 'package:warmreminders/features/schedules_page/models/requests/post_schedule_request.dart';
import 'package:warmreminders/features/schedules_page/schedules_page_api.dart';
import 'package:warmreminders/utils/storage_util.dart';
import 'package:warmreminders/widgets/add_item_button/add_item_button.dart';

class AddScheduleButton extends StatelessWidget {
  final VoidCallback onAdd;
  const AddScheduleButton({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    void addSchedule() async {
      final pushNotificationToken = await getPushNotificationToken();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if(pushNotificationToken == null){
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Please enable push notifications to allow setting notification time'),
          ),
        );
      }

      final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          helpText: "Set reminder time"
      );

      if (selectedTime != null) {
        final now = DateTime.now();
        var scheduledDataTimeUtc = DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute
        ).toUtc();

        final intervalHours = 24;

        if(now.toUtc().isAfter(scheduledDataTimeUtc)){
          scheduledDataTimeUtc = scheduledDataTimeUtc.add(Duration(days: 1));
        }

        await postSchedule(
            PostScheduleRequest(
                nextNotificationTimeUtc: scheduledDataTimeUtc,
                intervalHours: intervalHours
            )
        );

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Notifications scheduled for ${selectedTime.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );

        onAdd();
      }
    }
    
    return AddItemButton(onPressed: addSchedule);
  }
}
