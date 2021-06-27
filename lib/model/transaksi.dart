class Transaksi {
  int id;
  String namaPeminjam;
  String namaOrganisasi;
  String namaRuangan;
  String namaAcara;
  String pj;
  String kontak;
  String hp;
  int konfirmasiWRid;
  int konfirmasiKBUid;
  int konfirmasiKBSDid;
  String tanggalMulai;
  String tanggalSelesai;

  Transaksi(
      {this.id,
      this.namaPeminjam,
      this.namaOrganisasi,
      this.namaRuangan,
      this.namaAcara,
      this.pj,
      this.kontak,
      this.hp,
      this.konfirmasiWRid,
      this.konfirmasiKBUid,
      this.konfirmasiKBSDid,
      this.tanggalMulai,
      this.tanggalSelesai});

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
        id: json['id'] as int,
        namaPeminjam: json['nama_peminjam'] as String,
        namaOrganisasi: json['nama_organisasi'] as String,
        namaRuangan: json['nama_ruangan'] as String,
        namaAcara: json['nama_acara'] as String,
        pj: json['penanggung_jawab'] as String,
        kontak: json['kontak'] as String,
        hp: json['nomor_handphone'] as String,
        konfirmasiWRid: json['konfirmasi_wr_id'] as int,
        konfirmasiKBUid: json['konfirmasi_kbu_id'] as int,
        konfirmasiKBSDid: json['konfirmasi_kbsd_id'] as int,
        tanggalMulai: json['tanggal_mulai'] as String,
        tanggalSelesai: json['tanggal_selesai'] as String);
  }
}
