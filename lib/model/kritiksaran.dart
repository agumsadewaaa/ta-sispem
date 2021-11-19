class KritikSaran {
  int id;
  int transaksiId;
  String keluhan;
  String saran;
  String namaPeminjam;
  String namaRuangan;
  String mulai;
  String selesai;

  KritikSaran({
    this.id,
    this.transaksiId,
    this.keluhan,
    this.saran,
    this.namaPeminjam,
    this.namaRuangan,
    this.mulai,
    this.selesai,
  });

  factory KritikSaran.fromJson(Map<String, dynamic> json) {
    return KritikSaran(
        id: json['id'] as int,
        transaksiId: json['transaksi_id'] as int,
        keluhan: json['keluhan'] as String,
        saran: json['saran'] as String,
        namaPeminjam: json['nama_peminjam'] as String,
        namaRuangan: json['nama_ruangan'] as String,
        mulai: json['mulai'] as String,
        selesai: json['selesai'] as String);
  }
}
