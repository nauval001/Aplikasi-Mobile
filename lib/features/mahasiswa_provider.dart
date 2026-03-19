import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'mahasiswa_model.dart';
import 'mahasiswa_repository.dart';

final mahasiswaRepositoryProvider = Provider((ref) => MahasiswaRepository());

class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  MahasiswaNotifier(this._repository) : super(const AsyncValue.loading()) {
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
}

final mahasiswaNotifierProvider = StateNotifierProvider.autoDispose<MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>((ref) {
  return MahasiswaNotifier(ref.watch(mahasiswaRepositoryProvider));
});