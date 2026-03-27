import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import 'dosen_model.dart';

class DosenRepository {
  final DioClient _dioClient;

  DosenRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<DosenModel>> getDosenList() async {
    try {
      final response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat data dosen: ${e.response?.statusCode} ${e.message}');
    }
  }
}