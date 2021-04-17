class Transaksi {
  int id;
  String namaRuangan;
  int kapasitas;
  int penjagaId;

  Transaksi({this.id, this.namaRuangan, this.kapasitas, this.penjagaId});

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] as int,
      namaRuangan: json['nama_ruangan'] as String,
      kapasitas: json['kapasitas'] as int,
      penjagaId: json['penjaga_id'] as int,
    );
  }
}
