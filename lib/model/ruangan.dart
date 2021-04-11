class Ruangan {
  int id;
  String namaRuangan;
  int kapasitas;
  String myUrl = "https://f0aebd9c7c7b.ngrok.io/api/ruangans";

  Ruangan({this.id, this.namaRuangan, this.kapasitas});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'] as int,
      namaRuangan: json['nama_ruangan'] as String,
      kapasitas: json['kapasitas'] as int,
    );
  }
}
