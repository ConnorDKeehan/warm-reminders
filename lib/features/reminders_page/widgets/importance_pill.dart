import 'package:flutter/material.dart';
import 'package:warmreminders/widgets/action_pill/action_pill.dart';

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
  int _level = 3;

  String _stars(int count) =>
      '★' * count + '☆' * (ImportancePill._max - count);

  void _handleSelect(int newLevel) {
    setState(() => _level = newLevel);
    widget.onLevelSelected(newLevel);
  }

  Future<void> _showLevelDialog() async {
    final choice = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Importance'),
        children: List.generate(
          ImportancePill._max,
              (i) {
            final val = i + ImportancePill._min;
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, val),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_stars(val), style: const TextStyle(fontSize: 18)),
                  Text(
                    val == ImportancePill._min
                        ? 'Lowest'
                        : val == ImportancePill._max
                        ? 'Highest'
                        : '$val / ${ImportancePill._max}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (choice != null && choice != _level) {
      _handleSelect(choice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionPill(
      icon: Icons.star_border,
      label: _stars(_level),
      selected: true,
      onTap: _showLevelDialog,
    );
  }
}
