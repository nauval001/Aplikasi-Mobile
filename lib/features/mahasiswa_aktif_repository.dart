import 'package:dio/dio.dart';
import 'mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  final Dio _dio = Dio();

  Future<List<MahasiswaAktifModel>> getPostsList() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat post mahasiswa aktif');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}