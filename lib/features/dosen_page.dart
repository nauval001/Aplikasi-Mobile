import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/common_widgets.dart';
import 'dosen_provider.dart';
import 'dosen_widgets.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dosenNotifierProvider),
          ),
        ],
      ),
      body: dosenState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data dosen: ${error.toString()}',
          onRetry: () => ref.read(dosenNotifierProvider.notifier).refresh(),
        ),
        data: (dosenList) {
          return DosenListView(
            dosenList: dosenList,
            onRefresh: () => ref.invalidate(dosenNotifierProvider),
            useModernCard: true,
          );
        },
      ),
    );
  }
}