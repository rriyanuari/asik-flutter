class KaryawanModel {
  String? idKaryawan;
  String? namaLengkap;
  String? jenisKelamin;
  String? tanggalLahir;
  String? namaJabatan;
  String? tanggalGabung;
  String? logDatetime;
  
  KaryawanModel(
    this.idKaryawan,
    this.namaLengkap,
    this.jenisKelamin,
    this.tanggalLahir,
    this.namaJabatan,
    this.tanggalGabung,
    this.logDatetime,
  );

  KaryawanModel.fromJson(Map<String, dynamic> json) {
    idKaryawan= json["id_karyawan"];
    namaLengkap= json["nama_lengkap"];
    jenisKelamin= json["jenis_kelamin"];
    tanggalLahir= json["tanggal_lahir"];
    namaJabatan= json["nama_jabatan"];
    tanggalGabung= json["tanggal_gabung"];
    logDatetime= json["log_datetime"];
  }
}