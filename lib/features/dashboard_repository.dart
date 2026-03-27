import '../features/dashboard_model.dart';

class DashboardRepository {
  Future<DashboardData> getDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy
    return DashboardData(
      userName: 'Nauval Putra Dika Ramadhani',
      lastUpdate: DateTime.now(),
      stats: [
        DashboardStats(
          title: 'Total Mahasiswa',
          value: '1,234',
          subtitle: 'Mahasiswa terdaftar',
          percentage: 8.5,
          isIncrease: true,
        ),
        DashboardStats(
          title: 'Mahasiswa Aktif',
          value: '1,180',
          subtitle: 'Sedang kuliah',
          percentage: 5.2,
          isIncrease: true,
        ),
        DashboardStats(
          title: 'Jumlah Kelas',
          value: '48',
          subtitle: 'Kelas semester ini',
          percentage: 2.1,
          isIncrease: false,
        ),
        DashboardStats(
          title: 'Tingkat Kelulusan',
          value: '94%',
          subtitle: 'Tahun ini',
          percentage: 3.5,
          isIncrease: true,
        ),
      ],
    );
  }

  Future<DashboardData> refreshDashboard() async {
    return getDashboardData();
  }

  Future<DashboardStats?> getStatByTitle(String title) async {
    final data = await getDashboardData();
    try {
      return data.stats.firstWhere((stat) => stat.title == title);
    } catch (e) {
      return null;
    }
  }
}