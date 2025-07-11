import 'package:flutter/material.dart';

class LanguageDetectionIndicator extends StatelessWidget {
  final String? detectedLanguage;
  final Map<String, String> languages;
  
  const LanguageDetectionIndicator({
    super.key,
    required this.detectedLanguage,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (detectedLanguage == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Определен язык: ${languages[detectedLanguage] ?? detectedLanguage}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}