import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/translation_provider.dart';
import '../widgets/language_selector.dart';
import '../widgets/language_switcher.dart';
import '../widgets/translation_input.dart';
import '../widgets/translate_button.dart';
import '../widgets/translation_result.dart';
import '../widgets/language_detection_indicator.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _fromLang = 'auto';
  String _toLang = 'ru';

  final Map<String, String> languages = {
    'auto': 'Автоопределение',
    'en': 'Английский',
    'ru': 'Русский',
    'es': 'Испанский',
    'fr': 'Французский',
    'de': 'Немецкий',
    'it': 'Итальянский',
    'pt': 'Португальский',
    'zh': 'Китайский',
    'ja': 'Японский',
    'ar': 'Арабский',
  };

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = Provider.of<TranslationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой Переводчик'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context, theme),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLanguageSelectionCard(theme),
              const SizedBox(height: 12),
              LanguageDetectionIndicator(
                detectedLanguage: translationProvider.detectedLanguage,
                languages: languages,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TranslationInput(controller: _textController),
              ),
              const SizedBox(height: 16),
              TranslateButton(
                isLoading: translationProvider.isLoading,
                onPressed: () => _handleTranslate(translationProvider),
              ),
              const SizedBox(height: 16),
              TranslationResult(
                error: translationProvider.error,
                translatedText: translationProvider.translatedText,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textController.clear();
          FocusScope.of(context).unfocus();
        },
        tooltip: 'Очистить',
        child: const Icon(Icons.clear),
      ),
    );
  }

  Card _buildLanguageSelectionCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: LanguageSelector(
                value: _fromLang,
                items: languages.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _fromLang = value!),
                hint: 'С языка',
              ),
            ),
            LanguageSwitcher(
              onPressed: () => setState(() {
                final temp = _fromLang;
                _fromLang = _toLang;
                _toLang = temp == 'auto' ? 'en' : temp;
              }),
            ),
            Expanded(
              child: LanguageSelector(
                value: _toLang,
                items: languages.entries
                    .where((e) => e.key != 'auto')
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _toLang = value!),
                hint: 'На язык',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTranslate(TranslationProvider provider) {
    if (_textController.text.isNotEmpty) {
      provider.translateText(_textController.text, _fromLang, _toLang);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Введите текст для перевода'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context, ThemeData theme) {
    showAboutDialog(
      context: context,
      applicationName: 'Простой Переводчик',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.translate),
      children: [
        const Text('Использует MyMemory Translation API'),
        const SizedBox(height: 8),
        Text(
          'Поддерживает перевод между множеством языков',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}