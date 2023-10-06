DROP DATABASE IF EXISTS uts_mobile;

CREATE DATABASE uts_mobile;

USE uts_mobile;

CREATE TABLE buku (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255),
    penulis VARCHAR(255),
    tahun_terbit INT
);

INSERT INTO buku (judul, penulis, tahun_terbit) VALUES ("Laskar Pelangi", "Andrea Hirata", 2000);