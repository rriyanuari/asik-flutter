class BaseUrl {
  static String url = "http://192.168.1.9/api-asik/";
  static String paths = "http://192.168.1.9/api-asik/upload/";

  // LOGIN
  static String urlLogin = url + "api/login.php";

  // // KARYWAN
  static String urlListKaryawan = url + "api/karyawan/list.php";
  static String urlTambahKaryawan = url + "api/karyawan/add.php";
  static String urlUbahKaryawan = url + "api/karyawan/edit.php";
  static String urlHapusKaryawan = url + "api/karyawan/delete.php";

  // // JABATAN
  static String urlListJabatan = url + "api/jabatan/list.php";
  static String urlTambahJabatan = url + "api/jabatan/add.php";
  static String urlUbahJabatan = url + "api/jabatan/edit.php";
  static String urlHapusJabatan = url + "api/jabatan/delete.php";

  // ADD LOG ABSEN
  static String urlLogAbsen = url + "api/log_absen.php";
  static String urlLogAbsenPulang = url + "api/log_absen_pulang.php";
  static String urlListAbsen = url + "api/list_absen.php";

  //CEK TGL YANG SUDAH ADA
  static String urlLogAbsenPerson = url + "api/data_log_person.php";

  //ADD IJIN CUTI
  static String urlListIjinCuti = url + "api/ijin_cuti/list.php";
  static String urlTambahIjinCuti = url + "api/ijin_cuti/add.php";
  static String urlUbahIjinCuti = url + "api/ijin_cuti/edit.php";
  static String urlHapusIjinCuti = url + "api/ijin_cuti/delete.php";

  //PERSETUJUAN
  static String urlListPersetujuan = url + "api/persetujuan/list.php";
  static String urlSetujuPersetujuan = url + "api/persetujuan/setuju.php";
  static String urlTolakPersetujuan = url + "api/persetujuan/tolak.php";
}
