import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/common_widgets.dart';
import 'mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mahasiswaNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa', style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.pinkAccent, 
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (e, stack) => CustomErrorWidget(message: e.toString(), onRetry: () => ref.read(mahasiswaNotifierProvider.notifier).refresh()),
        data: (list) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(mahasiswaNotifierProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.pinkAccent, child: Text(item.name[0].toUpperCase(), style: const TextStyle(color: Colors.white))),
                  title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                    Text(item.email, style: const TextStyle(color: Colors.blue, fontSize: 12)), 
                    const SizedBox(height: 4), 
                    Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)) 
                  ]),
                )
              );
            }
          )
        )
      )
    );
  }
}