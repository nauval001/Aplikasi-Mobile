import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/common_widgets.dart';
import 'mahasiswa_model.dart';
import 'mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mahasiswaNotifierProvider);
    final savedUsers = ref.watch(savedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [ IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () => ref.invalidate(mahasiswaNotifierProvider)) ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SavedMahasiswaSection(savedUsers: savedUsers),
          const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 4), child: Text('Daftar Mahasiswa (Komentar)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          Expanded(
            child: state.when(
              loading: () => const LoadingWidget(),
              error: (e, stack) => CustomErrorWidget(message: 'Error: $e', onRetry: () => ref.read(mahasiswaNotifierProvider.notifier).refresh()),
              data: (list) => _MahasiswaListWithSave(mhsList: list),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedMahasiswaSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  const _SavedMahasiswaSection({required this.savedUsers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 6),
              const Text('Data Tersimpan di Local Storage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              savedUsers.maybeWhen(
                data: (users) => users.isNotEmpty ? TextButton.icon(
                  onPressed: () async {
                    await ref.read(mahasiswaNotifierProvider.notifier).clearSaved();
                    ref.invalidate(savedMahasiswaProvider);
                  },
                  icon: const Icon(Icons.delete_sweep_outlined, size: 14, color: Colors.red),
                  label: const Text('Hapus Semua', style: TextStyle(fontSize: 12, color: Colors.red)),
                ) : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          savedUsers.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Error', style: TextStyle(color: Colors.red)),
            data: (users) {
              if (users.isEmpty) return const Text('Belum ada data tersimpan.', style: TextStyle(fontSize: 12, color: Colors.grey));
              return Container(
                decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.pink.shade200)),
                child: ListView.separated(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.pink.shade100, indent: 12, endIndent: 12),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(radius: 14, backgroundColor: Colors.pink.shade100, child: Text('${index+1}', style: TextStyle(fontSize: 11, color: Colors.pink.shade700))),
                      title: Text(user['name'] ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref.read(mahasiswaNotifierProvider.notifier).removeSaved(user['id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MahasiswaListWithSave extends ConsumerWidget {
  final List<MahasiswaModel> mhsList;
  const _MahasiswaListWithSave({required this.mhsList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(mahasiswaNotifierProvider),
      child: ListView.builder(
        itemCount: mhsList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final mhs = mhsList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.pinkAccent, child: Text(mhs.name[0].toUpperCase(), style: const TextStyle(color: Colors.white))),
              title: Text(mhs.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(mhs.email, style: const TextStyle(color: Colors.blue)),
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                onPressed: () async {
                  await ref.read(mahasiswaNotifierProvider.notifier).saveSelected(mhs);
                  ref.invalidate(savedMahasiswaProvider);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${mhs.name} disimpan')));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}