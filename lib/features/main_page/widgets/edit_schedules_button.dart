import 'package:flutter/material.dart';
import 'package:warmreminders/features/schedules_page/schedules_page.dart';

class EditSchedulesButton extends StatelessWidget {
  const EditSchedulesButton({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSchedulePage() async {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SchedulesPage())
      );
    }

    return ElevatedButton.icon(
      onPressed: navigateToSchedulePage,
      icon: const Icon(Icons.access_time),
      label: const Text("Edit Reminder Times"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor
      ),
    );
  }
}
