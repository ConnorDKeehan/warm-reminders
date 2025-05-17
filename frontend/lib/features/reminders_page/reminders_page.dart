import 'package:flutter/material.dart';
import 'package:warmreminders/features/reminders_page/reminders_page_api.dart';
import 'package:warmreminders/features/reminders_page/widgets/add_reminder_button.dart';
import 'package:warmreminders/features/reminders_page/widgets/edit_schedules_button.dart';
import 'package:warmreminders/features/reminders_page/widgets/reminder_card.dart';
import 'package:warmreminders/models/entities/reminder.dart';
import 'package:warmreminders/utils/storage_util.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _MainPageState();
}

class _MainPageState extends State<RemindersPage> {
  List<Reminder> reminders = [];
  bool isLoading = true;

  @override
  void initState() {
    refreshReminders();
    super.initState();
  }

  void refreshReminders() async {
    setState(() {
      isLoading=true;
    });

    reminders = await getReminders();
    setUsersCategories(reminders.map((e) =>
      e.category?.isNotEmpty ?? false ?
      '${e.category![0].toUpperCase()}${e.category!.substring(1).toLowerCase()}' :
      null
    ).whereType<String>());
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ReminderCard(resyncMainPage: refreshReminders, reminder: reminder);
              },
            ),
      floatingActionButton: AddReminderButton(onAdded: refreshReminders),
    );
  }
}



