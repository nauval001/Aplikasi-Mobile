class MahasiswaAktifModel {
  final int id;
  final String title;
  final String body;

  MahasiswaAktifModel({required this.id, required this.title, required this.body});

  factory MahasiswaAktifModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaAktifModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}