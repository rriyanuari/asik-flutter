<?php

  //Import file
  include '../config/functions.php';

  header('Content-Type: text/xml');

  // Get Data from Form
  $idKaryawan     = $POST['id_karyawan'];

  $hasil = $db->query("DELETE FROM `karyawan` WHERE id_karyawan='$idKaryawan'");

  if($hasil){
    $response['success'] = 1;
    $response['message'] = "Berhasil dihapus";

    echo json_encode($response);
  }else{
    $response['success'] = 0;
    $response['message'] = "Data gagal dihapus";

    echo json_encode($response);
  }
  
?>
