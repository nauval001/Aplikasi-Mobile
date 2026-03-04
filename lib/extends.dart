class Mahasiswa {
  String nama;
  String nim;

  Mahasiswa(this.nama, this.nim);

  void info() {
    print("Nama: $nama, NIM: $nim");
  }
}

class MahasiswaAktif extends Mahasiswa {
  int semester;

  MahasiswaAktif(String nama, String nim, this.semester) : super(nama, nim);

  void infoAktif() {
    info();
    print("Status: Aktif (Semester $semester)");
  }
}

class MahasiswaAlumni extends Mahasiswa {
  int tahunLulus;

  MahasiswaAlumni(String nama, String nim, this.tahunLulus) : super(nama, nim);

  void infoAlumni() {
    info();
    print("Status: Alumni (Lulus Tahun $tahunLulus)");
  }
}

void main() {
  var mhsAktif = MahasiswaAktif("Anang", "123456", 4);
  var mhsAlumni = MahasiswaAlumni("Budi", "654321", 2023);

  print("=== Data Mahasiswa Aktif ===");
  mhsAktif.infoAktif();

  print("\n=== Data Mahasiswa Alumni ===");
  mhsAlumni.infoAlumni();
}