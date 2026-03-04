import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_constants.dart';
import 'core/app_theme.dart';
// Error merah di bawah ini akan hilang setelah kita buat dashboard_page.dart di tahap selanjutnya
import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  runApp(
    // ProviderScope adalah root untuk semua provider Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const DashboardPage(), // Akan error sementara sampai kita buat file ini
    );
  }
}