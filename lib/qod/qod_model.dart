class QodModel {
  final String text;
  final String author;

  const QodModel({required this.author, required this.text});

  factory QodModel.fromJson(Map<String, dynamic> json) => QodModel(
        author: json['author'] as String,
        text: json['quote'] as String,
      );
}
