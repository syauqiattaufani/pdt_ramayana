import 'dart:convert';
import 'package:pdt_ramayana/models/RamayanaModel.dart';
import 'package:pdt_ramayana/ramayana_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdt_ramayana/database/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'ramayana_home.dart';
import 'package:url_launcher/url_launcher.dart';

class ListAct extends StatefulWidget {
  const ListAct({super.key});

  @override
  State<ListAct> createState() => _ListActState();
}

class _ListActState extends State<ListAct> {
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  List<RamayanaModel> listAct = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    //menjalankan fungsi all RamayanaModel saat pertama kali dimuat
    _getAllRamayanaModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            isCollapsed: true,
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
            // suffixText: 'Search'
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 17),
        elevation: 7.20,
        toolbarHeight: 75,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_1),
            onPressed: () {},
          ),
        ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  size: 18),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          return Ramayana();
                        } ));
              }
          )
      ),

      body:
      Stack(

        children: <Widget>[

          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 150,
              // width: 500,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 15, 15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 3,
                    blurRadius: 3,
                  )
                ],
              )
          ),

          Container(
            margin: EdgeInsets.only(left: 10, top: 20),
            child: Text('List Activity',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700)
            ),
          ),

          Container(
              margin: EdgeInsets.only(left: 230, top: 90),
              child: Text('Adhelia Putri Wardhana',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)
              )
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
            height: 70,

            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 5)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: <Widget>[
                Text('ALL',
                    style: TextStyle(
                        color: Color.fromARGB(221, 101, 89, 89),
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                Text('TRASH',
                    style: TextStyle(
                        color: Color.fromARGB(221, 101, 89, 89),
                        fontSize: 17,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 190 ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 5)
              ],
            ),
            child:

            ListView.builder(
                itemCount: listAct.length,
                itemBuilder: (context, index) {
                  RamayanaModel activityy = listAct[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      leading:  Text('${activityy.kode_toko}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),) ,
                      title: Text('${activityy.sku}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 17, 17), fontWeight: FontWeight.w500, fontSize: 20)),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                            ),
                            child: Text("Kode Lokasi: ${activityy.kode_lokasi}",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                            ),
                            child: Text("Quantity: ${activityy.qty}",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                            ),
                            child: Text("Tanggal: ${activityy.date}",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                          ),

                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            // button edit
                            IconButton(
                              onPressed: () {
                                _openFormEdit(activityy);
                              },
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 255, 17, 17),
                            ),
                            // button hapus
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Color.fromARGB(255, 255, 17, 17),
                              onPressed: () {
                                //membuat dialog konfirmasi hapus
                                AlertDialog hapus = AlertDialog(
                                  title: Text("Information"),
                                  content: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          // height: 70.0,
                                            width: 300,
                                            child:
                                            Text(
                                                "Yakin hapus data ${activityy.sku}?")

                                        ),
                                      ),
                                    ],),
                                  //terdapat 2 button.
                                  //jika ya maka jalankan _deleteKontak() dan tutup dialog
                                  //jika tidak maka tutup dialog
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          _deleteRamayanaModel(activityy, index);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ya",
                                            style: TextStyle(
                                                color:  Color.fromARGB(255, 255, 17, 17), fontWeight: FontWeight.w500, fontSize: 17)
                                        )
                                    ),

                                    TextButton(
                                      child: Text('Tidak',
                                          style: TextStyle(
                                              color:  Color.fromARGB(255, 255, 17, 17), fontWeight: FontWeight.w500, fontSize: 17)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                                showDialog(
                                    context: context, builder: (context) => hapus);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )

        ],),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 255, 17, 17),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) {
                      return ScanBarcode();
                    }));
          }
      ),
    );
  }

  //mengambil semua data RamayanaModel
  Future<void> _getAllRamayanaModel() async {
    //list menampung data dari database
    var list = await db.getAllRamayanaModel();

    //ada perubahan state
    setState(() {
      //hapus data pada listRamayanaModel
      listAct.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((pdt) {

        //masukkan data ke RamayanaModel
        listAct.add(RamayanaModel.fromMap(pdt));
      });
    });
  }

  //menghapus data RamayanaModel
  Future<void> _deleteRamayanaModel(RamayanaModel pdt, int position) async {
    await db.deleteRamayanaModel(pdt.id_act!);
    setState(() {
      listAct.removeAt(position);
    });
  }

  //membuka halaman tambah RamayanaModel
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
      this.context, MaterialPageRoute(builder: (context) => ScanBarcode()));
    if (result == 'save') {
      await _getAllRamayanaModel();
    }
  }

  //membuka halaman edit RamayanaModel
  Future<void> _openFormEdit(RamayanaModel pdt) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScanBarcode(pdt: pdt)));
    if (result == 'update') {
      await _getAllRamayanaModel();
    }
  }
}