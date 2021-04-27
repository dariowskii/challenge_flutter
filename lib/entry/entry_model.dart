class EntryModel {
  final String text;
  final String mood;
  final String title;
  final String data;

  const EntryModel(
      {required this.mood,
      required this.text,
      required this.title,
      required this.data});

  factory EntryModel.fromMap(Map<String, dynamic> map) => EntryModel(
        mood: map['mood'] as String,
        text: map['text'] as String,
        title: map['title'] as String,
        data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int)
            .toLocal()
            .toString(),
      );
}
