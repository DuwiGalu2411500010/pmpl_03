import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://reqres.in/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'page': 2,
        },
      );

      final List<dynamic> data = response.data['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return 'Server error: ${e.response?.statusCode}\n${e.response?.data}';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Koneksi timeout.';
      case DioExceptionType.receiveTimeout:
        return 'Waktu menerima data habis.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server.';
      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }
}
