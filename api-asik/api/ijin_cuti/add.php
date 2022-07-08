<?php

  include '../../config/functions.php';
  
  // header('Content-Type: text/xml');

  $namaTabel = "ijin_cuti";

  // Get Data from Form 
  $id_user           = $_POST['id_user'];
  $jenis_ijin        = $_POST['jenis_ijin'];
  $tanggal_awal      = $_POST['tanggal_awal'];
  $tanggal_akhir     = $_POST['tanggal_akhir'];
  $alasan            = $_POST['alasan'];
  $persetujuan       = 0;


  // $pangkat           = "tes";
  // // $masa_kerja        = "5";
  // $status_kawin      = "ok";
  // $bpjs              = "ok";
 

  // if(!$namaJabatan){
  //   $response['success'] = 0;
  //   $response['message'] = "Data kosong";
  //   echo json_encode($response);
  //   return die(); 
  // } 

  // $cek = $db->get_results("SELECT * FROM `$namaTabel` WHERE `nama_jabatan` = '$namaJabatan'");

  // // Cek data sudah ada?
  // if($cek){
  //   $response['success'] = 0;
  //   $response['message'] = "Data sudah ada";
  //   echo json_encode($response);
  //   return die(); 
  // }

  // Insert data
  $sql = $db->query("INSERT INTO `ijin_cuti`(`id_user`, `jenis_ijin`, `tanggal_awal`, `tanggal_akhir`, `alasan`, `persetujuan`) VALUES ('$id_user','$jenis_ijin','$tanggal_awal','$tanggal_akhir','$alasan','$persetujuan')");

  if($sql){
    $response['success'] = 1;
    $response['message'] = "Berhasil Tambah Ijin";
    echo json_encode($response);
  }else{
    $response['success'] = 0;
    $response['message'] = "Ijin Gagal Disimpan";
    echo json_encode($response);
  }

?>