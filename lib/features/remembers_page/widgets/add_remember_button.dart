import 'package:flutter/material.dart';
import 'package:warmreminders/features/remembers_page/models/post_remember_request.dart';
import 'package:warmreminders/features/remembers_page/remembers_page_api.dart';
import 'package:warmreminders/styles/app_styles.dart';
import 'package:warmreminders/widgets/add_item_button/add_item_button.dart';

class AddRememberButton extends StatefulWidget {
  final VoidCallback onAdded;
  const AddRememberButton({super.key, required this.onAdded});

  @override
  State<AddRememberButton> createState() => _AddRememberButtonState();
}

class _AddRememberButtonState extends State<AddRememberButton> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void handleAdd() async {
    final title = _titleController.text.trim();
    String? description = _descriptionController.text.trim();

    if (title.isEmpty) return;

    if(description.isEmpty) description = null;

    final request = PostRememberRequest(
      title: title,
      description: description
    );
    await postRemember(request);

    widget.onAdded();

    _titleController.clear();
    _descriptionController.clear();

    Navigator.of(context).pop();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,      // let it grow above the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Remember title?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Remember description?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            // add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: handleAdd,
                  style: AppStyles.submitButtonStyle,
                  child: const Text('Add')
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddItemButton(onPressed: _showBottomSheet);
  }
}


