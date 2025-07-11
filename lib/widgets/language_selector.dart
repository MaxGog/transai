import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  const LanguageSelector({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      hint: Text(hint),
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      style: theme.textTheme.bodyLarge,
    );
  }
}