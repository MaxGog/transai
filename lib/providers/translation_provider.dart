import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationProvider with ChangeNotifier {
  String _translatedText = '';
  bool _isLoading = false;
  String _error = '';
  String? _detectedLanguage;

  String get translatedText => _translatedText;
  bool get isLoading => _isLoading;
  String get error => _error;
  String? get detectedLanguage => _detectedLanguage;

  Future<void> translateText(String text, String fromLang, String toLang) async {
    _isLoading = true;
    _error = '';
    _translatedText = '';
    notifyListeners();

    try {
      final apiKey = dotenv.env['MYMEMORY_API_KEY'];
      final encodedText = Uri.encodeComponent(text);
      final langPair = '${fromLang == 'auto' ? 'en' : fromLang}|$toLang';
      
      final url = Uri.https(
        'api.mymemory.translated.net',
        '/get',
        {
          'q': text,
          'langpair': langPair,
          if (apiKey != null && apiKey.isNotEmpty) 'key': apiKey,
          'of': 'json',
          'mt': '1'
        },
      );

      debugPrint("Sending request to: $url");

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['responseStatus'] == 200) {
        String translated = data['responseData']['translatedText'];
        _translatedText = _cleanTranslatedText(translated);
        
        double matchQuality = data['responseData']['match']?.toDouble() ?? 0;
        if (matchQuality < 0.7) {
          _error = 'Качество перевода может быть низким';
        }

        if (fromLang == 'auto') {
          _detectedLanguage = _detectSourceLanguage(data);
        }
      } else {
        _error = data['responseDetails'] ?? 'Неизвестная ошибка API';
      }
    } on SocketException {
      _error = 'Нет подключения к интернету';
    } on TimeoutException {
      _error = 'Сервер не отвечает';
    } catch (e) {
      _error = 'Ошибка: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _cleanTranslatedText(String input) {
    try {
      String decoded = input.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16))
      );
      
      decoded = Uri.decodeFull(decoded);
      
      decoded = decoded.replaceAll(RegExp(r'%[0-9a-fA-F]{2}'), '');
      
      return decoded;
    } catch (e) {
      return input;
    }
  }

  String? _detectSourceLanguage(Map<String, dynamic> data) {
    try {
      if (data['matches'] is List && data['matches'].isNotEmpty) {
        final match = data['matches'][0];
        if (match['source'] is String) {
          return match['source'].toString().split('-')[0];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}