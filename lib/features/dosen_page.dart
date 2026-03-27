import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/common_widgets.dart';
import 'dosen_model.dart';
import 'dosen_provider.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    final savedUsers = ref.watch(savedDosenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dosenNotifierProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SavedDosenSection(savedUsers: savedUsers),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Daftar Dosen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: dosenState.when(
              loading: () => const LoadingWidget(),
              error: (e, stack) => CustomErrorWidget(
                message: 'Gagal memuat data dosen: $e',
                onRetry: () => ref.read(dosenNotifierProvider.notifier).refresh(),
              ),
              data: (list) => _DosenListWithSave(dosenList: list),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedDosenSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  const _SavedDosenSection({required this.savedUsers});

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2,'0')}';
    } catch (_) { return '-'; }
  }

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
                    await ref.read(dosenNotifierProvider.notifier).clearSavedDosen();
                    ref.invalidate(savedDosenProvider);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua data dihapus')));
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
            error: (_, __) => const Text('Gagal membaca data', style: TextStyle(color: Colors.red, fontSize: 12)),
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  width: double.infinity, padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text('Belum ada data. Tap ikon disk untuk menyimpan.', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)),
                child: ListView.separated(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green.shade100, indent: 12, endIndent: 12),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(radius: 14, backgroundColor: Colors.green.shade100, child: Text('${index+1}', style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.bold))),
                      title: Text(user['name'] ?? '-'),
                      subtitle: Text('ID: ${user['id']} • ${_formatDate(user['saved_at'] ?? '')}', style: const TextStyle(fontSize: 11)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref.read(dosenNotifierProvider.notifier).removeSavedDosen(user['id'] ?? '');
                          ref.invalidate(savedDosenProvider);
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user['name']} dihapus')));
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

class _DosenListWithSave extends ConsumerWidget {
  final List<DosenModel> dosenList;
  const _DosenListWithSave({required this.dosenList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dosenNotifierProvider),
      child: ListView.builder(
        itemCount: dosenList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Text(dosen.id.toString(), style: const TextStyle(color: Colors.blue))),
              title: Text(dosen.name),
              subtitle: Text('${dosen.username} • ${dosen.email}\n${dosen.address.city}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan user ini',
                onPressed: () async {
                  await ref.read(dosenNotifierProvider.notifier).saveSelectedDosen(dosen);
                  ref.invalidate(savedDosenProvider);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${dosen.name} berhasil disimpan ke local storage')));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}