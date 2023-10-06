<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Koneksi ke db
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "uts_mobile";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Koneksi ke db gagal: ".$conn->connect_error);
}

$method = $_SERVER["REQUEST_METHOD"];

if ($method === "GET") {
    // Mengambil data buku
    $query = "SELECT * FROM buku";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $buku = array();
        while ($row = $result->fetch_assoc()) {
            $buku[] = $row;
        }
        echo json_encode($buku);
    } else {
        echo "Data buku kosong";
    }
}


if ($method === "POST") {
    // Menambahkan data buku
    $data = json_decode(file_get_contents("php://input"), true);
    $judul = $data["judul"];
    $penulis = $data["penulis"];
    $tahun_terbit = $data["tahun_terbit"];

    $query = "INSERT INTO buku (judul, penulis, tahun_terbit) VALUES('$judul', '$penulis', $tahun_terbit);";
    if ($conn->query($query) === TRUE) {
        $data["pesan"] = "berhasil";
    } else {
        $data["pesan"] = "Error: " . $query . "<br>" . $conn->error;
    }
    echo json_encode($data);
}

if ($method === "PUT") {
    // Memperbarui data buku
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $judul = $data["judul"];
    $penulis = $data["penulis"];
    $tahun_terbit = $data["tahun_terbit"];

    $query = "UPDATE buku SET judul='$judul', penulis='$penulis', tahun_terbit=$tahun_terbit WHERE id=$id;";
    if ($conn->query($query) === TRUE) {
        $data["pesan"] = "berhasil";
    } else {
        echo "Error: " . $query . "<br>" . $conn->error;
    }
    echo json_encode($data);
}

if ($method === "DELETE") {
    // Menghapus data buku
    $id = $_GET["id"];

    $query = "DELETE FROM buku WHERE id=$id";
    if ($conn->query($query) === TRUE) {
        $data["pesan"] = "berhasil";
    } else {
        $data["pesan"] = "Error: " . $query . "<br>" . $conn->error;
    }

    echo json_encode($data);
}

$conn->close();
?>
