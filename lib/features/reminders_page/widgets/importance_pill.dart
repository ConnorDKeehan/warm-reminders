import 'package:flutter/material.dart';

class ImportancePill extends StatefulWidget {
  final ValueChanged<int> onLevelSelected;

  static const _min = 1;
  static const _max = 5;

  const ImportancePill({
    super.key,
    required this.onLevelSelected,
  });

  @override
  State<ImportancePill> createState() => _ImportancePillState();
}

class _ImportancePillState extends State<ImportancePill> {
  int level = 3; //default level
  String _stars(int count) => '★' * count + '☆' * (ImportancePill._max - count);

  void handleSelectImportance(int importance){
    setState(() {
      level = importance;
    });

    widget.onLevelSelected(importance);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final choice = await showDialog<int>(
          context: context,
          builder: (ctx) => SimpleDialog(
            title: const Text('Select Importance'),
            children: List.generate(ImportancePill._max, (i) {
              final val = i + ImportancePill._min;
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, val),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_stars(val), style: const TextStyle(fontSize: 18)),
                    // optional hint text:
                    Text(val == ImportancePill._min
                        ? 'Lowest'
                        : val == ImportancePill._max
                        ? 'Highest'
                        : '$val / ${ImportancePill._max}',
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              );
            }),
          ),
        );
        if (choice != null && choice != level) {
          handleSelectImportance(choice);
        }
      },
      child: Chip(
        label: Text(_stars(level)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        deleteIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onDeleted: () {}, // just to show the dropdown icon
      ),
    );
  }
}
