import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mahasiswa_model.dart';

class MahasiswaRepository {
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MahasiswaModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat komentar mahasiswa');
    }
  }
}