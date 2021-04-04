// THIS FILE IS UNDER DEVELOPMENT (it will be added to main app with 0.3beta release)

class Language {
  // default as english
  static String langSelected = 'en';

  final _lang = {
    'pt-br': [
      {
        'None playlist created!': 'Nenhuma playlist criada!',
      }
    ],
    'en': [
      {
        'None playlist creates!': 'None playlist creates!',
      }
    ],
  };

  void getPhrase(String target) {
    // TODO: implement a return to get lang phrases
    return null;
  }
}
