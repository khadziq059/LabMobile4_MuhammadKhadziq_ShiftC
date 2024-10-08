import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

//ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk Muhammad Khadziq || H1D022059'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kode : ${widget.produk!.kodeProduk}",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Nama : ${widget.produk!.namaProduk}",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10),
              Text(
                "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 30),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat Tombol Hapus/Edit
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blue[600],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("EDIT", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk!),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        // Tombol Delete
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("DELETE", style: TextStyle(color: Colors.white)),
          onPressed: _isLoading ? null : () => confirmHapus(),
        ),
      ],
    );
  }

  // Fungsi untuk konfirmasi hapus
  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol hapus
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Ya", style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ProdukPage(),
                  ),
                );
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            ).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            });
          },
        ),
        // Tombol batal
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text("Batal", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
