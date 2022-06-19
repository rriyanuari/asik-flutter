class BaseUrl {
  static String url = "http://192.168.154.76/api-asik/";
  static String paths = "http://192.168.154.76/api-asik/upload/";

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
}
