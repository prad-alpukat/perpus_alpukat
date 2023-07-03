CREATE DATABASE perpus_alpukat;

USE perpus_alpukat;

CREATE TABLE role (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(15)
);

CREATE TABLE user (
  username VARCHAR(15) PRIMARY KEY,
  password VARCHAR(35),
  id_role INT,
  FOREIGN KEY (id_role) REFERENCES role(id)
);

CREATE TABLE buku (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(100),
  tahun_terbit DATE,
  sinopsis TEXT,
  penerbit VARCHAR(35),
  lokasi VARCHAR(35)
);

CREATE TABLE peminjaman (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tgl DATE,
  denda INT,
  pengurus VARCHAR(15),
  peminjam VARCHAR(15),
  FOREIGN KEY (pengurus) REFERENCES user(username),
  FOREIGN KEY (peminjam) REFERENCES user(username)
);

CREATE TABLE pengembalian (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tgl DATE,
  tgl_jatuh_tempo DATE,
  pengurus VARCHAR(15),
  peminjam VARCHAR(15),
  FOREIGN KEY (pengurus) REFERENCES user(username),
  FOREIGN KEY (peminjam) REFERENCES user(username)
);

-- Dummy data untuk tabel role
INSERT INTO role (nama) VALUES
('Admin'),
('Pustakawan'),
('Anggota');

-- Dummy data untuk tabel user
INSERT INTO user (username, password, id_role) VALUES
('admin123', 'adminpass', 1),
('pustakawan1', 'pustakawanpass', 2),
('anggota1', 'anggotapass', 3);

-- Dummy data untuk tabel buku
INSERT INTO buku (judul, tahun_terbit, sinopsis, penerbit, lokasi) VALUES
('Buku A', '2020-01-01', 'Sinopsis buku A', 'Penerbit X', 'Rak A1'),
('Buku B', '2019-05-15', 'Sinopsis buku B', 'Penerbit Y', 'Rak B2'),
('Buku C', '2022-11-30', 'Sinopsis buku C', 'Penerbit Z', 'Rak C3');

-- Dummy data untuk tabel peminjaman
INSERT INTO peminjaman (tgl, denda, pengurus, peminjam) VALUES
('2023-06-20', 0, 'admin123', 'anggota1'),
('2023-06-18', 0, 'pustakawan1', 'anggota1');

-- Dummy data untuk tabel pengembalian
INSERT INTO pengembalian (tgl, tgl_jatuh_tempo, pengurus, peminjam) VALUES
('2023-06-24', '2023-06-22', 'admin123', 'anggota1'),
('2023-06-23', '2023-06-21', 'pustakawan1', 'anggota1');

