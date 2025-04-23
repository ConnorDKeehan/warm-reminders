import 'package:flutter/material.dart';
import 'package:warmreminders/features/main_page/main_page_api.dart';
import 'package:warmreminders/features/main_page/widgets/add_reminder_button.dart';
import 'package:warmreminders/features/main_page/widgets/edit_schedules_button.dart';
import 'package:warmreminders/features/main_page/widgets/reminder_card.dart';
import 'package:warmreminders/features/schedules_page/schedules_page_api.dart';
import 'package:warmreminders/features/schedules_page/widgets/add_schedule_button.dart';
import 'package:warmreminders/features/schedules_page/widgets/schedule_card.dart';
import 'package:warmreminders/models/entities/reminder.dart';
import 'package:warmreminders/models/entities/schedule.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  List<Schedule> schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    refreshSchedules();
    super.initState();
  }

  void refreshSchedules() async {
    setState(() {
      isLoading=true;
    });

    schedules = await getSchedules();
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Schedules")
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return ScheduleCard(resyncMainPage: refreshSchedules, schedule: schedule);
        },
      ),
      floatingActionButton: AddScheduleButton(onAdd: refreshSchedules),
    );
  }
}



