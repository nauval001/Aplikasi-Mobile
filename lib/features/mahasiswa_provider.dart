import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/local_storage_service.dart';
import 'dosen_provider.dart';
import 'mahasiswa_model.dart';
import 'mahasiswa_repository.dart';

final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) => MahasiswaRepository());

final savedMahasiswaProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedMahasiswa();
});

class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  final LocalStorageService _storage;

  MahasiswaNotifier(this._repository, this._storage) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async => await loadData();

  Future<void> saveSelected(MahasiswaModel mhs) async => await _storage.saveMahasiswa(mhs.id.toString(), mhs.name);
  Future<void> removeSaved(String id) async => await _storage.removeSavedMahasiswa(id);
  Future<void> clearSaved() async => await _storage.clearSavedMahasiswa();
}

final mahasiswaNotifierProvider = StateNotifierProvider.autoDispose<MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>((ref) {
  return MahasiswaNotifier(ref.watch(mahasiswaRepositoryProvider), ref.watch(localStorageServiceProvider));
});