// this file is under development, it will be added to main app with 0.3beta release

class Language {
  static String langSelected = 'en';

  static final lang = {
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
    return lang[target];
  }
}
