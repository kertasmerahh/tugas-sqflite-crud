import 'package:flutter/material.dart';
import 'package:crud_sqflite/data/repo/barang_repo.dart';
import 'package:crud_sqflite/model/barang.dart';
import 'package:get/get.dart'; 

class BarangController extends GetxController {
  final BarangRepo repo;
  BarangController(this.repo);

  var barangList = <Barang>[].obs;

  @override
  void onInit() {
    super.onInit();
    getBarang();
  }

  Future<void> getBarang() async {
    try {
      barangList.value = await repo.getAllBarang();
      Get.snackbar("Sukses", "Berhasil", backgroundColor: Colors.lightGreen);
    } catch (e) {
      Get.snackbar("Error", "Gagal", backgroundColor: Colors.red);
    }
  }

  Future<void> tambahBarang(Barang barang) async {
  try {
    await repo.insert(barang);

    await getBarang();

    Get.snackbar(
      "Sukses",
      "Barang dengan nama ${barang.nama} Berhasil ditambahkan",
      backgroundColor: Colors.lightGreen,
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      "Gagal",
      backgroundColor: Colors.red,
    );
  }
}

  Future<void> ubahBarang(Barang barang) async {
    try {
      await repo.update(barang);

      await getBarang();

      Get.snackbar(
        "Sukses",
        "Barang berhasil diubah",
        backgroundColor: Colors.lightGreen,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengubah barang",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> hapusBarang(int id) async {
    try {
      await repo.delete(id);

      await getBarang();

      Get.snackbar(
        "Sukses",
        "Barang berhasil dihapus",
        backgroundColor: Colors.lightGreen,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus barang",
        backgroundColor: Colors.red,
      );
    }
  }
}