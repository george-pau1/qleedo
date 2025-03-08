class BibleItem {
  String chapter;
  String capterName;
  String abbriName;
  List<int> verse;

  BibleItem({required this.chapter, required this.capterName, required this.verse, required this.abbriName});

  factory BibleItem.fromJson(Map<String, dynamic> json) {
    return BibleItem(
        chapter: json['chapter'],
        capterName: json['name'],
        abbriName: json['Abbreviation'],
        verse: json['verses']);
  }
}
