import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'mahasiswa_aktif_model.dart';
import 'mahasiswa_aktif_repository.dart';

final mahasiswaAktifRepositoryProvider = Provider((ref) => MahasiswaAktifRepository());

class MahasiswaAktifNotifier extends StateNotifier<AsyncValue<List<MahasiswaAktifModel>>> {
  final MahasiswaAktifRepository _repository;
  MahasiswaAktifNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getPostsList();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  Future<void> refresh() async => await loadData();
}

final mahasiswaAktifNotifierProvider = StateNotifierProvider.autoDispose<MahasiswaAktifNotifier, AsyncValue<List<MahasiswaAktifModel>>>((ref) {
  return MahasiswaAktifNotifier(ref.watch(mahasiswaAktifRepositoryProvider));
});