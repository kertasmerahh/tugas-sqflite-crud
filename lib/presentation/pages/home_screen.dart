
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_sqflite/model/barang.dart';
import 'package:crud_sqflite/presentation/controller/barang_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
Future<void> tampilkanForm(
  BuildContext context,
  BarangController ctr, {
  Barang? barang,
}) async {
  final namaController = TextEditingController(
    text: barang?.nama ?? '',
  );

  final stokController = TextEditingController(
    text: barang?.stok.toString() ?? '',
  );

  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          barang == null ? "Tambah Barang" : "Edit Barang",
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Barang",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama barang tidak boleh kosong";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Barang",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Stok tidak boleh kosong";
                  }

                  final stok = int.tryParse(value);

                  if (stok == null || stok < 0) {
                    return "Masukkan angka 0 atau lebih";
                  }

                  return null;
                },
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text("Batal"),
          ),

          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final nama = namaController.text.trim();
                final stok = int.parse(stokController.text);

                if (barang == null) {
                  await ctr.tambahBarang(
                    Barang(
                      nama: nama,
                      stok: stok,
                    ),
                  );
                } else {
                  await ctr.ubahBarang(
                    barang.copyWith(
                      nama: nama,
                      stok: stok,
                    ),
                  );
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      );
    },
  );
}


  void konfirmasiHapus(
    BuildContext context,
    BarangController ctr,
    Barang barang,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Barang"),
          content: Text(
            "Apakah kamu yakin ingin menghapus ${barang.nama}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ctr.hapusBarang(barang.id!);
                Navigator.pop(context);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<BarangController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Barang"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "LIST BARANG",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (ctr.barangList.isEmpty) {
                return const Center(
                  child: Text("Data Belum Ada"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: ctr.barangList.length,
                itemBuilder: (context, index) {
                  final barang = ctr.barangList[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        barang.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "Stok: ${barang.stok}",
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              tampilkanForm(
                                context,
                                ctr,
                                barang: barang,
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              konfirmasiHapus(
                                context,
                                ctr,
                                barang,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          tampilkanForm(context, ctr);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
