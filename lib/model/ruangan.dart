class Ruangan {
  int id;
  String namaRuangan;
  int kapasitas;
  String namaPenjaga;
  String kontak;
  String status;

  Ruangan(
      {this.id,
      this.namaRuangan,
      this.kapasitas,
      this.namaPenjaga,
      this.kontak,
      this.status});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
        id: json['id'] as int,
        namaRuangan: json['nama_ruangan'] as String,
        kapasitas: json['kapasitas'] as int,
        namaPenjaga: json['nama_penjaga'] as String,
        kontak: json['nomor_handphone'] as String,
        status: json['status'] as String);
  }
}
