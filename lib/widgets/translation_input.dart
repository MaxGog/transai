import 'package:flutter/material.dart';

class TranslationInput extends StatelessWidget {
  final TextEditingController controller;
  
  const TranslationInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Введите текст для перевода...',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}