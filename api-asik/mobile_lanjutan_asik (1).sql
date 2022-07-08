-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2022 at 01:26 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mobile_lanjutan_asik`
--

-- --------------------------------------------------------

--
-- Table structure for table `ijin_cuti`
--

CREATE TABLE `ijin_cuti` (
  `id_ijin` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `jenis_ijin` varchar(50) NOT NULL,
  `tanggal_awal` date NOT NULL,
  `tanggal_akhir` date NOT NULL,
  `alasan` varchar(255) NOT NULL,
  `persetujuan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ijin_cuti`
--

INSERT INTO `ijin_cuti` (`id_ijin`, `id_user`, `jenis_ijin`, `tanggal_awal`, `tanggal_akhir`, `alasan`, `persetujuan`) VALUES
(1, 1, 'Cuti', '2022-06-10', '2022-06-13', 'keperluan keluarga', 2),
(2, 2, 'Ijin', '2022-06-07', '2022-06-09', 'mengantar anak', 1),
(3, 10, 'Cuti', '2022-05-11', '2022-05-19', 'pulang kampung', 0),
(5, 2, 'Ijin', '2022-06-28', '2022-06-28', 'mengantar anak', 2),
(6, 2, 'Sakit', '2022-06-28', '2022-07-01', 'mencret', 1),
(7, 1, 'Sakit', '2022-06-29', '2022-06-30', 'diare dan demam', 0),
(8, 1, 'Cuti', '2022-06-29', '2022-08-03', 'Liburan', 0),
(9, 1, 'Sakit', '2022-06-29', '2022-06-29', 'sakit', 1);

-- --------------------------------------------------------

--
-- Table structure for table `jabatan`
--

CREATE TABLE `jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `nama_jabatan` varchar(60) NOT NULL,
  `log_datetime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jabatan`
--

INSERT INTO `jabatan` (`id_jabatan`, `nama_jabatan`, `log_datetime`) VALUES
(1, 'Manager Operasional', '2022-04-12 11:08:28'),
(2, 'Manager FAT', '2022-04-12 11:08:28'),
(3, 'Staff IT', '2022-04-12 11:09:04'),
(5, 'anak baru', '2022-06-12 13:31:13');

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id_karyawan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `jenis_kelamin` enum('laki-laki','perempuan') NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `tanggal_gabung` date NOT NULL,
  `log_datetime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id_karyawan`, `id_user`, `nama_lengkap`, `jenis_kelamin`, `tanggal_lahir`, `id_jabatan`, `tanggal_gabung`, `log_datetime`) VALUES
(1, 1, 'Hamdani', 'laki-laki', '2003-03-03', 1, '2002-02-02', '2022-03-26 23:41:40'),
(2, 2, 'Riyan', 'perempuan', '1999-01-02', 2, '2020-02-20', '2022-04-15 23:05:26'),
(25, 2, 'Kaka', 'perempuan', '2022-06-12', 3, '2022-07-01', '2022-06-12 13:59:52');

-- --------------------------------------------------------

--
-- Table structure for table `log_absen`
--

CREATE TABLE `log_absen` (
  `id_absen` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `date` date NOT NULL,
  `jam_masuk` time NOT NULL,
  `jam_pulang` time NOT NULL,
  `Keterangan` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `log_absen`
--

INSERT INTO `log_absen` (`id_absen`, `id_karyawan`, `date`, `jam_masuk`, `jam_pulang`, `Keterangan`) VALUES
(45, 1, '2022-05-25', '00:00:00', '03:27:56', 'Cuti'),
(46, 2, '2022-05-25', '00:00:00', '03:44:55', 'Cuti'),
(48, 1, '2022-05-26', '00:00:00', '20:34:29', 'Absen'),
(49, 2, '2022-05-26', '20:21:06', '20:23:19', 'Cuti'),
(50, 1, '2022-06-11', '09:04:21', '00:00:00', 'Absen'),
(51, 1, '2022-06-11', '09:04:21', '00:00:00', 'Absen'),
(52, 1, '2022-06-12', '08:50:49', '17:46:47', 'Absen'),
(53, 2, '2022-06-12', '00:00:00', '15:01:55', 'Absen'),
(54, 1, '2022-06-17', '00:00:00', '21:02:31', 'Absen'),
(55, 10, '2022-06-17', '00:00:00', '20:56:39', 'Absen'),
(56, 2, '2022-06-17', '00:00:00', '21:02:08', 'Absen'),
(57, 1, '2022-06-18', '09:45:21', '00:00:00', 'Absen'),
(58, 2, '2022-06-28', '00:00:00', '21:13:35', 'Sakit'),
(195, 1, '2022-06-29', '06:20:32', '00:00:00', 'Absen'),
(196, 2, '2022-06-29', '00:00:00', '00:00:00', 'Sakit'),
(197, 2, '2022-06-30', '00:00:00', '00:00:00', 'Sakit'),
(198, 2, '2022-07-01', '00:00:00', '00:00:00', 'Sakit');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `jenis_kelamin` enum('laki-laki','perempuan') NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `tanggal_gabung` date NOT NULL,
  `pangkat` varchar(100) NOT NULL,
  `masa_kerja` int(11) NOT NULL,
  `status_kawin` varchar(50) NOT NULL,
  `bpjs` varchar(50) NOT NULL,
  `log_datetime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `email`, `status`, `nama_lengkap`, `jenis_kelamin`, `tanggal_lahir`, `id_jabatan`, `tanggal_gabung`, `pangkat`, `masa_kerja`, `status_kawin`, `bpjs`, `log_datetime`) VALUES
(1, 'hamdani', 'admin', '', 1, 'Hamdani', 'laki-laki', '2000-02-02', 1, '2021-01-01', '', 0, '', '', '2022-03-26 23:19:30'),
(2, 'riyan', 'karyawan', '', 2, 'Riyan', 'laki-laki', '2001-01-01', 20, '2022-02-02', '', 0, '', '', '2022-03-26 23:19:30'),
(10, 'prayoga', '123', 'prayoga@gmail.com', 2, 'prayoga', 'laki-laki', '2022-06-01', 0, '2022-06-17', 'letnan', 2, 'Belum Menikah', 'bpjs', '2022-06-17 20:56:19'),
(12, 'joko', '123', 'ok', 1, 'joko', 'laki-laki', '2022-06-18', 3, '2022-06-18', 'pejabat', 24, 'kawin', 'ok', '2022-06-18 10:14:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ijin_cuti`
--
ALTER TABLE `ijin_cuti`
  ADD PRIMARY KEY (`id_ijin`);

--
-- Indexes for table `jabatan`
--
ALTER TABLE `jabatan`
  ADD PRIMARY KEY (`id_jabatan`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indexes for table `log_absen`
--
ALTER TABLE `log_absen`
  ADD PRIMARY KEY (`id_absen`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ijin_cuti`
--
ALTER TABLE `ijin_cuti`
  MODIFY `id_ijin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `jabatan`
--
ALTER TABLE `jabatan`
  MODIFY `id_jabatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id_karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `log_absen`
--
ALTER TABLE `log_absen`
  MODIFY `id_absen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
