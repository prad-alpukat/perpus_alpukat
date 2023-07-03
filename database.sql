-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 03, 2023 at 03:41 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `perpus_alpukat`
--

-- --------------------------------------------------------

--
-- Table structure for table `anggota`
--

CREATE TABLE `anggota` (
  `nik` varchar(16) NOT NULL,
  `nama` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `anggota`
--

INSERT INTO `anggota` (`nik`, `nama`) VALUES
('2222', 'test'),
('3333', 'test333'),
('3572447103910001', 'Jane Smith'),
('3576447103910003', 'John Doe');

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `tahun_terbit` year(4) NOT NULL,
  `sinopsis` text NOT NULL,
  `penerbit` varchar(35) NOT NULL,
  `lokasi` varchar(35) NOT NULL,
  `total_stok` int(11) NOT NULL,
  `stok_terkini` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id`, `judul`, `tahun_terbit`, `sinopsis`, `penerbit`, `lokasi`, `total_stok`, `stok_terkini`) VALUES
(1, 'One Piece', 2017, 'One Piece adalah sebuah manga dan anime yang menceritakan petualangan seorang bajak laut bernama Monkey D. Luffy dan kru bajak lautnya dalam mencari harta karun legendaris bernama \"One Piece\".', 'Shueisha', 'rak A10', 1089, 56),
(2, 'Naruto', 2000, 'Naruto adalah sebuah manga dan anime yang mengisahkan tentang petualangan seorang ninja remaja bernama Naruto Uzumaki dalam menjadi Hokage, pemimpin desa Konoha. Cerita ini juga mengangkat tema persahabatan dan perjuangan.', 'Shueisha', 'rak A11', 80, 80),
(3, 'Attack on Titan', 2011, 'Attack on Titan, yang dikenal juga sebagai Shingeki no Kyojin, adalah sebuah manga dan anime yang berlatar di dunia yang dihuni oleh para raksasa pemakan manusia. Cerita ini mengikuti perjuangan manusia dalam melawan raksasa-raksasa tersebut.', 'Kodansha', 'rak A10', 50, 51),
(4, 'One Punch Man', 2016, 'One Punch Man adalah sebuah manga dan anime yang mengisahkan tentang Saitama, seorang pahlawan super yang memiliki kekuatan tak terbatas dan mampu mengalahkan musuh dengan satu pukulan saja. Meskipun begitu, Saitama merasa bosan karena tidak ada yang mampu memberinya tantangan yang sepadan.', 'Shueisha', 'rak B1', 60, 59),
(5, 'My Hero Academia', 2005, 'My Hero Academia, atau dikenal juga sebagai Boku no Hero Academia, adalah sebuah manga dan anime yang berlatar di dunia di mana hampir semua orang memiliki kekuatan super atau \"Quirk\". Cerita ini mengikuti petualangan seorang remaja bernama Izuku Midoriya yang bermimpi menjadi seorang pahlawan super.', 'Shueisha', 'rak B3', 120, 120);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id` int(11) NOT NULL,
  `tgl` date NOT NULL,
  `tgl_jatuh_tempo` date NOT NULL,
  `nik_anggota` varchar(16) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `status` enum('dipinjam','kembali') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id`, `tgl`, `tgl_jatuh_tempo`, `nik_anggota`, `id_buku`, `status`) VALUES
(1, '2023-06-26', '2023-06-29', '3572447103910001', 1, 'dipinjam'),
(4, '2023-07-03', '2023-07-10', '3572447103910001', 1, 'kembali'),
(5, '2023-07-03', '2023-07-10', '3576447103910003', 1, 'kembali'),
(6, '2023-07-03', '2023-07-10', '3572447103910001', 4, 'dipinjam');

-- --------------------------------------------------------

--
-- Table structure for table `pengurus`
--

CREATE TABLE `pengurus` (
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengurus`
--

INSERT INTO `pengurus` (`username`, `password`) VALUES
('admin', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `tamu`
--

CREATE TABLE `tamu` (
  `id` int(11) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `tanggal_input` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tamu`
--

INSERT INTO `tamu` (`id`, `nama`, `tanggal_input`) VALUES
(1, 'test', '2023-07-02 19:29:37'),
(2, 'testing', '2023-07-02 19:29:41'),
(3, 'praditya aldi syahputra', '2023-07-02 19:29:53'),
(4, 'test', '2023-07-02 19:36:54'),
(5, 'hello ', '2023-07-02 19:36:58'),
(6, 'hello ', '2023-07-02 19:37:22'),
(7, 'test', '2023-07-02 19:37:43'),
(8, 'test', '2023-07-02 19:38:20'),
(9, 'test', '2023-07-02 19:38:22'),
(10, 'test', '2023-07-02 19:38:28'),
(11, 'test', '2023-07-02 19:38:33'),
(12, 'test', '2023-07-02 19:38:37'),
(13, 'test', '2023-07-02 19:42:03'),
(14, 'test', '2023-07-02 19:42:15'),
(15, 'test', '2023-07-02 19:42:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anggota`
--
ALTER TABLE `anggota`
  ADD PRIMARY KEY (`nik`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nik_anggota` (`nik_anggota`),
  ADD KEY `peminjaman_ibfk_2` (`id_buku`);

--
-- Indexes for table `pengurus`
--
ALTER TABLE `pengurus`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `tamu`
--
ALTER TABLE `tamu`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tamu`
--
ALTER TABLE `tamu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`nik_anggota`) REFERENCES `anggota` (`nik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
