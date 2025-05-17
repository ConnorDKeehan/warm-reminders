import 'package:flutter/material.dart';
import 'package:warmreminders/features/remembers_page/remembers_page_api.dart';
import 'package:warmreminders/features/remembers_page/widgets/add_remember_button.dart';
import 'package:warmreminders/features/remembers_page/widgets/remember_card.dart';
import 'package:warmreminders/models/entities/remember.dart';

class RemembersPage extends StatefulWidget {
  const RemembersPage({super.key});

  @override
  State<RemembersPage> createState() => _RemembersPageState();
}

class _RemembersPageState extends State<RemembersPage> {
  List<Remember> remembers = [];
  bool isLoading = true;

  @override
  void initState() {
    refreshRemembers();
    super.initState();
  }

  void refreshRemembers() async {
    setState(() {
      isLoading=true;
    });

    remembers = await getRemembers();
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
        itemCount: remembers.length,
        itemBuilder: (context, index) {
          final remember = remembers[index];
          return RememberCard(resyncMainPage: refreshRemembers, remember: remember);
        },
      ),
      floatingActionButton: AddRememberButton(onAdded: refreshRemembers),
    );
  }
}



