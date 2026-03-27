import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import 'mahasiswa_model.dart';

class MahasiswaRepository {
  final DioClient _dioClient;
  MahasiswaRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      final response = await _dioClient.dio.get('/comments');
      final List<dynamic> data = response.data;
      return data.map((json) => MahasiswaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat data: ${e.message}');
    }
  }
}