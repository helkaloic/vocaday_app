extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (length < 2) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get routePath => substring(1);

  String toTitleCase() {
    List<String> words = split(' ');

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }

    return words.join(' ');
  }
}