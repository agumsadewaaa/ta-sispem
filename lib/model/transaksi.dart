class Transaksi {
  int id;
  String namaRuangan;
  String kontak;
  int konfirmasiWRid;
  int konfirmasiKBUid;
  int konfirmasiKBSDid;

  Transaksi(
      {this.id,
      this.namaRuangan,
      this.kontak,
      this.konfirmasiWRid,
      this.konfirmasiKBUid,
      this.konfirmasiKBSDid});

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] as int,
      namaRuangan: json['nama_ruangan'] as String,
      kontak: json['nomor_handphone'] as String,
      konfirmasiWRid: json['konfirmasi_wr_id'] as int,
      konfirmasiKBUid: json['konfirmasi_kbu_id'] as int,
      konfirmasiKBSDid: json['konfirmasi_kbsd_id'] as int,
    );
  }
}
