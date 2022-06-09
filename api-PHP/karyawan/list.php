<?php

  //Import file
  include '../../config/functions.php';

  // header('Content-Type: text/xml');

  // query sql karyawan
  $rssql = "SELECT * FROM karyawan";

  // mendapatkan hasil
  $sql = mysqli_query($con, $rssql);

  // deklarasi array
  $response = array();

  while($a = mysqli_fetch_array($sql)){
   
    $idJabatan = $a['id_jabatan'];
    $sqlJabatan = "SELECT * FROM jabatan WHERE $idJabatan";

    $sql2 = mysqli_query($con, $sqlJabatan);
    $jabatan = mysqli_fetch_array($sql2);


    // memasukan data field kedalam variabel
    $b['id_karyawan']     = $a['id_karyawan'];
    $b['nama_lengkap']    = $a['nama_lengkap'];
    $b['jenis_kelamin']   = $a['jenis_kelamin'];
    $b['tanggal_lahir']   = $a['tanggal_lahir'];
    $b['nama_jabatan']    = $jabatan['nama_jabatan'];
    $b['tanggal_gabung']  = $a['tanggal_gabung'];
    $b['log_datetime']    = $a['log_datetime'];

    array_push($response, $b);
  }

  echo json_encode($response);

;?>
