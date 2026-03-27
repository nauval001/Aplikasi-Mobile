import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/local_storage_service.dart';
import 'dosen_model.dart';
import 'dosen_repository.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) => LocalStorageService());
final dosenRepositoryProvider = Provider<DosenRepository>((ref) => DosenRepository());

final savedDosenProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedDosen();
});

class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;
  final LocalStorageService _storage;

  DosenNotifier(this._repository, this._storage) : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async => await loadDosenList();

  Future<void> saveSelectedDosen(DosenModel dosen) async {
    await _storage.saveDosen(dosen.id.toString(), dosen.name);
  }
  Future<void> removeSavedDosen(String id) async => await _storage.removeSavedDosen(id);
  Future<void> clearSavedDosen() async => await _storage.clearSavedDosen();
}

final dosenNotifierProvider = StateNotifierProvider.autoDispose<DosenNotifier, AsyncValue<List<DosenModel>>>((ref) {
  return DosenNotifier(ref.watch(dosenRepositoryProvider), ref.watch(localStorageServiceProvider));
});