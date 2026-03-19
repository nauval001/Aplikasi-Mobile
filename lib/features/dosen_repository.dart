import 'package:dio/dio.dart';
import 'dosen_model.dart';

class DosenRepository {
  final Dio _dio = Dio();

  Future<List<DosenModel>> getDosenList() async {
    try {
      // Mengambil data dari API
      final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => DosenModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dosen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}