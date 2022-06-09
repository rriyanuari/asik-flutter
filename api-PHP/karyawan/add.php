<?php
  include '../config/functions.php';
  
  // header('Content-Type: text/xml');

  // Get Data from Form 
  $idUser    = $POST['idUser'];
  $namaLengkap    = $POST['namaLengkap'];
  $jenisKelamin   = $POST['jenisKelamin'];
  $tanggalLahir   = $POST['tanggalLahir'];
  $idJabatan      = $POST['idJabatan'];
  $tanggalGabung  = $POST['tanggalGabung'];

  if(!$namaLengkap){
    $response['success'] = 0;
    $response['message'] = "Data kosong";
    echo json_encode($response);
    return false; 
  } 

  $cek = $db->get_results("SELECT * FROM `karywan` WHERE `nama_lengkap` = '$namaLengkap'");

  // Cek data sudah ada?
  if($cek){
    $response['success'] = 0;
    $response['message'] = "Data sudah ada";
    echo json_encode($response);
    return false; 
  }

  // Insert data
  $sql = $db->query("INSERT INTO `karywan` VALUES(NULL, '$idUser', '$namaLengkap', '$jenisKelamin', '$tanggalLahir', '$idJabatan', '$tanggalGabung', NOW())");

  if($sql){
    $response['success'] = 1;
    $response['message'] = "Berhasil Tambah Data";

    echo json_encode($response);
  }else{
    $response['success'] = 0;
    $response['message'] = "Data Gagal Disimpan";
    
    echo json_encode($response);
  }
?>