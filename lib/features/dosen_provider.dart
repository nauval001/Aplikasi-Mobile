import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'dosen_model.dart';
import 'dosen_repository.dart';

final dosenRepositoryProvider = Provider<DosenRepository>((ref) => DosenRepository());

class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;
  DosenNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async => await loadDosenList();
}

final dosenNotifierProvider = StateNotifierProvider.autoDispose<DosenNotifier, AsyncValue<List<DosenModel>>>((ref) {
  return DosenNotifier(ref.watch(dosenRepositoryProvider));
});