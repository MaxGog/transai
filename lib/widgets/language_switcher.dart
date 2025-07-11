import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  final VoidCallback onPressed;
  
  const LanguageSwitcher({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IconButton(
      icon: Icon(Icons.swap_horiz, color: theme.colorScheme.primary),
      onPressed: onPressed,
    );
  }
}