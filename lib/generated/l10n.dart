// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Scan Product`
  String get scanProduct {
    return Intl.message(
      'Scan Product',
      name: 'scanProduct',
      desc: '',
      args: [],
    );
  }

  /// `Scan Text`
  String get scanText {
    return Intl.message(
      'Scan Text',
      name: 'scanText',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission denied.\nCamera permission must be enabled.`
  String get requestPermission {
    return Intl.message(
      'Camera permission denied.\nCamera permission must be enabled.',
      name: 'requestPermission',
      desc: '',
      args: [],
    );
  }

  /// `Click to Enable`
  String get clickToEnable {
    return Intl.message(
      'Click to Enable',
      name: 'clickToEnable',
      desc: '',
      args: [],
    );
  }

  /// `Boycott this {pro} Product`
  String boycottThisProduct(Object pro) {
    return Intl.message(
      'Boycott this $pro Product',
      name: 'boycottThisProduct',
      desc: '',
      args: [pro],
    );
  }

  /// `An error occurred while scanning text`
  String get anErrorOccurredWhileScanningText {
    return Intl.message(
      'An error occurred while scanning text',
      name: 'anErrorOccurredWhileScanningText',
      desc: '',
      args: [],
    );
  }

  /// `This {pro} product is very good`
  String thisProductIsVeryGood(Object pro) {
    return Intl.message(
      'This $pro product is very good',
      name: 'thisProductIsVeryGood',
      desc: '',
      args: [pro],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Something happened`
  String get someThingHappened {
    return Intl.message(
      'Something happened',
      name: 'someThingHappened',
      desc: '',
      args: [],
    );
  }

  /// `Sent successfully`
  String get successSend {
    return Intl.message(
      'Sent successfully',
      name: 'successSend',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get thisFieldRequired {
    return Intl.message(
      'This field is required',
      name: 'thisFieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get boycottProduct {
    return Intl.message(
      'Add Product',
      name: 'boycottProduct',
      desc: '',
      args: [],
    );
  }

  /// `Is this {pro} the name of the product`
  String isThisTheProductName(Object pro) {
    return Intl.message(
      'Is this $pro the name of the product',
      name: 'isThisTheProductName',
      desc: '',
      args: [pro],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `تم غلق الكاميرا`
  String get cameraClosed {
    return Intl.message(
      'تم غلق الكاميرا',
      name: 'cameraClosed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
