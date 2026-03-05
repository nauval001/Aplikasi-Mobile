import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_constants.dart';
import '../core/common_widgets.dart';
import 'dashboard_provider.dart';
import 'dashboard_widgets.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memantau data dari provider
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final selectedIndex = ref.watch(selectedStatIndexProvider);

    return Scaffold(
      body: dashboardState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data: ${error.toString()}',
          onRetry: () {
            ref.read(dashboardNotifierProvider.notifier).refresh();
          },
        ),
        data: (dashboardData) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(dashboardNotifierProvider.notifier).refresh();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DashboardHeader(userName: dashboardData.userName),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Statistik",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppConstants.paddingMedium,
                            mainAxisSpacing: AppConstants.paddingMedium,
                            childAspectRatio: 1.3,
                          ),
                          itemCount: dashboardData.stats.length,
                          itemBuilder: (context, index) {
                            return StatCard(
                              stats: dashboardData.stats[index],
                              isSelected: selectedIndex == index,
                              onTap: () {
                                ref.read(selectedStatIndexProvider.notifier).state = index;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: AppConstants.paddingLarge),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(dashboardNotifierProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Memperbarui data...'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}