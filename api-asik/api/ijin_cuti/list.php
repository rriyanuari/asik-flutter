<?php

  //Import file
  include '../../config/functions.php';

  // header('Content-Type: text/xml');
  $idUSer = $_POST['id_user'];
  
  $rssql = "SELECT * FROM ijin_cuti WHERE id_user=$idUSer";

  // mendapatkan hasil
  $sql = mysqli_query($con, $rssql);

  // deklarasi array
  $response = array();

  while($a = mysqli_fetch_array($sql)){
   
    


    // memasukan data field kedalam variabel
    $b['id_user']         = $a['id_user'];
    $b['id_ijin']         = $a['id_ijin'];
    $b['jenis_ijin']      = $a['jenis_ijin'];
    $b['tanggal_awal']    = $a['tanggal_awal'];
    $b['tanggal_akhir']   = $a['tanggal_akhir'];
    $b['alasan']          = $a['alasan'];
    $b['persetujuan']     = $a['persetujuan'];
   
    array_push($response, $b);
  }

  echo json_encode($response);

;?>
