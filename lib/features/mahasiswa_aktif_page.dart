import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/common_widgets.dart';
import 'mahasiswa_aktif_provider.dart';

class MahasiswaAktifPage extends ConsumerWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mahasiswaAktifNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Aktif', style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.green, 
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (e, stack) => CustomErrorWidget(message: e.toString(), onRetry: () => ref.read(mahasiswaAktifNotifierProvider.notifier).refresh()),
        data: (list) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(mahasiswaAktifNotifierProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.green.shade100, child: const Icon(Icons.article, color: Colors.green)),
                  title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  ),
                )
              );
            }
          )
        )
      )
    );
  }
}