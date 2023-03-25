
enum AffirmationTypes { tx, yau, yvi }

extension ParseToString on AffirmationTypes {
  String toShortString() {
    return toString().split('.').last;
  }
}
