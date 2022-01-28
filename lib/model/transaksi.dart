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
  int konfirmasiKSBRTid;
  String tanggalMulai;
  String tanggalSelesai;
  int status;
  int pkwr2;
  String pkwr2Tgl;
  int pkbu;
  String pkbuTgl;
  int pkbsd;
  String pkbsdTgl;
  int pksbrt;
  String pksbrtTgl;

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
      this.konfirmasiKSBRTid,
      this.tanggalMulai,
      this.tanggalSelesai,
      this.status,
      this.pkwr2,
      this.pkwr2Tgl,
      this.pkbsd,
      this.pkbsdTgl,
      this.pkbu,
      this.pkbuTgl,
      this.pksbrt,
      this.pksbrtTgl});

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
        konfirmasiKSBRTid: json['konfirmasi_ksbrt_id'] as int,
        tanggalMulai: json['tanggal_mulai'] as String,
        tanggalSelesai: json['tanggal_selesai'] as String,
        status: json['status'] as int,
        pkwr2: json['pwr2_status'] as int,
        pkwr2Tgl: json['pkwr2_tgl'] as String,
        pkbsd: json['pkbsd_status'] as int,
        pkbsdTgl: json['pkbsd_tgl'] as String,
        pkbu: json['pkbu_status'] as int,
        pkbuTgl: json['pkbu_tgl'] as String,
        pksbrt: json['pksbrt_status'] as int,
        pksbrtTgl: json['pksbrt_tgl'] as String);
  }
}
