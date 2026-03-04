import 'dart:io';

void main() {
  List<String> dataList = ['a', 'b', 'c', 'd', 'e'];

  // Tampil berdasarkan index tertentu
  stdout.write('Masukkan index yang ingin ditampilkan: ');
  int indexTampil = int.parse(stdin.readLineSync() ?? '0');
  if (indexTampil >= 0 && indexTampil < dataList.length) {
    print('Data pada index $indexTampil: ${dataList[indexTampil]}');
  }

  // Ubah berdasarkan index tertentu
  stdout.write('Masukkan index yang ingin diubah: ');
  int indexUbah = int.parse(stdin.readLineSync() ?? '0');
  stdout.write('Masukkan data baru: ');
  String dataBaru = stdin.readLineSync() ?? '';
  if (indexUbah >= 0 && indexUbah < dataList.length) {
    dataList[indexUbah] = dataBaru;
    print('Data berhasil diubah!');
  }

  // Hapus berdasarkan index tertentu
  stdout.write('Masukkan index yang ingin dihapus: ');
  int indexHapus = int.parse(stdin.readLineSync() ?? '0');
  if (indexHapus >= 0 && indexHapus < dataList.length) {
    dataList.removeAt(indexHapus);
    print('Data berhasil dihapus!');
  }

  // Tampilkan hasil akhir sesuai format
  print('\n=== SEMUA DATA ===');
  for (int i = 0; i < dataList.length; i++) {
    print('Index $i: ${dataList[i]}');
  }
}