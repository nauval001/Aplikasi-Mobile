import 'dart:io';

void main() {
  List<Map<String, dynamic>> listMahasiswa = [];

  print('=== INPUT MULTIPLE MAHASISWA ===');
  stdout.write('Masukkan jumlah mahasiswa: ');
  int jumlah = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  for (int i = 0; i < jumlah; i++) {
    print('\n--- Mahasiswa ke- ---${i + 1}');
    stdout.write('Masukkan NIM: ');
    String nim = stdin.readLineSync() ?? '';
    
    stdout.write('Masukkan Nama: ');
    String nama = stdin.readLineSync() ?? '';
    
    stdout.write('Masukkan Jurusan: ');
    String jurusan = stdin.readLineSync() ?? '';
    
    stdout.write('Masukkan IPK: ');
    double ipk = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

    Map<String, dynamic> mahasiswa = {
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'ipk': ipk
    };
    
    listMahasiswa.add(mahasiswa);
  }

  print('\n=== HASIL AKHIR DATA MAHASISWA ===');
  for (var mhs in listMahasiswa) {
    print(mhs);
  }
}