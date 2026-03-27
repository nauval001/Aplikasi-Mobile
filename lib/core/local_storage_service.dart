import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  
  static const String _savedDosenKey = 'saved_dosen';
  static const String _savedMahasiswaKey = 'saved_mahasiswa';
  static const String _savedMahasiswaAktifKey = 'saved_mahasiswa_aktif';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<void> _addToList(String key, String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(key) ?? [];
    
    final isDuplicate = rawList.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'].toString() == id;
    });
    if (isDuplicate) return;

    final newItem = jsonEncode({
      'id': id,
      'name': name,
      'saved_at': DateTime.now().toIso8601String(),
    });
    rawList.add(newItem);
    await prefs.setStringList(key, rawList);
  }

  Future<List<Map<String, String>>> _getSavedList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(key) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return {
        'id': map['id'].toString(),
        'name': map['name'].toString(),
        'saved_at': map['saved_at'].toString(),
      };
    }).toList();
  }

  Future<void> _removeFromList(String key, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(key) ?? [];
    rawList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'].toString() == id;
    });
    await prefs.setStringList(key, rawList);
  }

  Future<void> _clearList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> saveDosen(String id, String name) => _addToList(_savedDosenKey, id, name);
  Future<List<Map<String, String>>> getSavedDosen() => _getSavedList(_savedDosenKey);
  Future<void> removeSavedDosen(String id) => _removeFromList(_savedDosenKey, id);
  Future<void> clearSavedDosen() => _clearList(_savedDosenKey);

  Future<void> saveMahasiswa(String id, String name) => _addToList(_savedMahasiswaKey, id, name);
  Future<List<Map<String, String>>> getSavedMahasiswa() => _getSavedList(_savedMahasiswaKey);
  Future<void> removeSavedMahasiswa(String id) => _removeFromList(_savedMahasiswaKey, id);
  Future<void> clearSavedMahasiswa() => _clearList(_savedMahasiswaKey);

  Future<void> saveMahasiswaAktif(String id, String title) => _addToList(_savedMahasiswaAktifKey, id, title);
  Future<List<Map<String, String>>> getSavedMahasiswaAktif() => _getSavedList(_savedMahasiswaAktifKey);
  Future<void> removeSavedMahasiswaAktif(String id) => _removeFromList(_savedMahasiswaAktifKey, id);
  Future<void> clearSavedMahasiswaAktif() => _clearList(_savedMahasiswaAktifKey);
}