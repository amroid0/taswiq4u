import 'dart:async';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/utils/global_locale.dart';

import '../shared_prefs.dart';

class TranslationsBloc implements Bloc {
  StreamController<String> _languageController = StreamController<String>();
  Stream<String> get currentLanguage => _languageController.stream;

  StreamController<Locale> _localeController = StreamController<Locale>();
  Stream<Locale> get currentLocale => _localeController.stream;

  @override
  void dispose() {
    _languageController?.close();
    _localeController?.close();
  }

  void setNewLanguage(String newLanguage) async {
    // Save the selected language as a user preference
    await preferences.saveLangauge(newLanguage);

    // Notification the translations module about the new language
    await allTranslations.setNewLanguage(newLanguage);

    _languageController.sink.add(newLanguage);
    _localeController.sink.add(allTranslations.locale);
  }
}