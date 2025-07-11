import 'package:flutter/material.dart';

class TranslationResult extends StatelessWidget {
  final String? error;
  final String? translatedText;
  
  const TranslationResult({
    super.key,
    this.error,
    this.translatedText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (error != null && error!.isNotEmpty) {
      return _buildErrorWidget(context, theme, error!);
    } else if (translatedText != null && translatedText!.isNotEmpty) {
      return _buildTranslationWidget(theme, translatedText!);
    }
    return const SizedBox.shrink();
  }

  Widget _buildErrorWidget(BuildContext context, ThemeData theme, String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationWidget(ThemeData theme, String text) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Text(text, style: theme.textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }
}