import 'dart:io';

void main() {
  Set<String> dataSet = {'a','b','c','d','e'};

  print('=== SEMUA DATA ===');
  int counter = 1;
  for (var item in dataSet) {
    print('$counter. $item');
    counter++;
  }
  print('Total data: ${dataSet.length}');
  print('');

  // Tambah Data
  stdout.write('Masukkan data baru: ');
  String newData = stdin.readLineSync() ?? '';
  dataSet.add(newData);
  print('Data "$newData" berhasil ditambahkan!\n');

  // Hapus Data
  stdout.write('Masukkan data yang ingin dihapus: ');
  String delData = stdin.readLineSync() ?? '';
  if (dataSet.remove(delData)) {
    print('Data "$delData" berhasil dihapus!\n');
  } else {
    print('Data "$delData" tidak ditemukan!\n');
  }

  // Cek Data
  stdout.write('Masukkan data yang ingin dicek: ');
  String checkData = stdin.readLineSync() ?? '';
  if (dataSet.contains(checkData)) {
    print('Data "$checkData" ada di Set!');
  } else {
    print('Data "$checkData" tidak ada di Set!');
  }
}