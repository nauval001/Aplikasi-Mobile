// Mixin 1
mixin Penelitian {
  void meneliti() => print("Sedang melakukan penelitian akademik.");
}

// Mixin 2
mixin Organisasi {
  void rapat() => print("Sedang mengikuti rapat BEM/HIMA.");
}

// Mixin 3
mixin Mengajar {
  void ngajar() => print("Sedang memberikan materi perkuliahan.");
}

// Kelas Dasar
class CivitasAkademika {
  String nama;
  CivitasAkademika(this.nama);
}

// Implementasi Mixin pada Child Class
class Mahasiswa extends CivitasAkademika with Penelitian, Organisasi {
  Mahasiswa(String nama) : super(nama);
}

class Dosen extends CivitasAkademika with Penelitian, Mengajar {
  Dosen(String nama) : super(nama);
}

void main() {
  var mahasiswa = Mahasiswa("Nauva");
  var dosen = Dosen("Pak Rendi");

  print("Kegiatan Mahasiswa (${mahasiswa.nama}):");
  mahasiswa.meneliti();
  mahasiswa.rapat();

  print("\nKegiatan Dosen (${dosen.nama}):");
  dosen.meneliti();
  dosen.ngajar();
}