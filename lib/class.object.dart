import 'dart:io';

class Mahasiswa {
  String? nama;
  int? nim;
  String? jurusan;

  void tampilkanData() {
    print("Nama: ${nama ?? 'Belum diisi'}");
    print("NIM: ${nim ?? 'Belum diisi'}");
    print("Jurusan: ${jurusan ?? 'Belum diisi'}");
  }
}

void main() {
  Mahasiswa mahasiswa = Mahasiswa();
  
  print("Masukkan Nama Mahasiswa: ");
  mahasiswa.nama = stdin.readLineSync();
  
  print("Masukkan NIM Mahasiswa: ");
  mahasiswa.nim = int.tryParse(stdin.readLineSync() ?? '');
  
  print("Masukkan Jurusan Mahasiswa: ");
  mahasiswa.jurusan = stdin.readLineSync();

  print("\n=== Hasil Data ===");
  mahasiswa.tampilkanData();
}