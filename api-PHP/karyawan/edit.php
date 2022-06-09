<?php

  //Import file
  include '../config/functions.php';

  header('Content-Type: text/xml');

  $namaTabel = "jabatan";

  // Get Data from Form
  $idUser    = $POST['idUser'];
  $namaLengkap    = $POST['namaLengkap'];
  $jenisKelamin   = $POST['jenisKelamin'];
  $tanggalLahir   = $POST['tanggalLahir'];
  $idJabatan      = $POST['idJabatan'];
  $tanggalGabung  = $POST['tanggalGabung'];

  if(!$namaLengkap || !$idUser){
    $response['success'] = 0;
    $response['message'] = "Data kosong";

    echo json_encode($response);
    return false; 
  } 

  $hasil  = $db->query("UPDATE $nama_tabel SET 
                          nama_lengkap = '$namaLengkap', 
                          jenis_kelamin = '$jenisKelamin', 
                          tanggalLahir = '$tanggalLahir', 
                          idJabatan = '$idJabatan', 
                          tanggalGabung = '$idJabatan', 
                          log_datetime = NOW()
                        WHERE id_karyawan='$idKaryawan'");
  
  if($hasil){
    $response['success'] = 1;
    $response['message'] = "Berhasil diupdate";

    echo json_encode($response);
  }else{
    $response['success'] = 0;
    $response['message'] = "Data gagal diupdate";

    echo json_encode($response);
  }
;?>
