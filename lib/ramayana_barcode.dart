import 'package:pdt_ramayana/database/db_helper.dart';
import 'package:pdt_ramayana/models/RamayanaModel.dart';

import 'data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ScanBarcode extends StatefulWidget {
  // const ScanBarcode({super.key});
  final RamayanaModel? pdt;

  ScanBarcode({this.pdt});

  @override
  State<ScanBarcode> createState() => _ScanBarcode();
}

class _ScanBarcode extends State<ScanBarcode> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DbHelper db = DbHelper();

  TextEditingController? sku;
  TextEditingController? kode_lokasi;
  TextEditingController? kode_toko;
  TextEditingController? qty;
  TextEditingController? date;

  var savedData = [];

  getSavedData() async {
    var data = await Data.getData();
    // setelah data didapat panggil setState agar data segera dirender
    setState(() {
      savedData = data;
    });
  }

  @override
 void initState() {
    sku = TextEditingController(
        text: widget.pdt == null ? '' : widget.pdt!.sku
    );

    kode_lokasi = TextEditingController(
      text: widget.pdt == null ? '' : widget.pdt!.kode_lokasi
    );

    kode_toko = TextEditingController(
        text: widget.pdt == null ? '' : widget.pdt!.kode_toko
    );

    qty = TextEditingController(
        text: widget.pdt == null ? '' : widget.pdt!.qty
    );

    date = TextEditingController(
        text: widget.pdt == null ? '' : widget.pdt!.date
    );
    super.initState();
  }

  var dio = Dio();
  late Size ukuranLayar;
  var akses = 'usr';

  @override

  void initStateDate() {
    // databaseInstance.database();

    date!.text = ""; //set the initial value of text field
    super.initState();
    getSavedData();
  }

  String _scanBarcode = '';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  String _scanBarcode2 = '';

  Future<void> startBarcodeScanStream2() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcode2() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode2 = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan'),
          backgroundColor: Color.fromARGB(255, 255, 17, 17),
          elevation: 7.20  ,
          toolbarHeight: 75,
        ),
        body:

        Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  width: 500,
                  child:
                  Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            color: Color.fromARGB(255, 227, 0, 0)
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 30),
                            width: 500,
                            height: 50,
                            color: Color.fromARGB(255, 239, 237, 237),
                            child:
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 20),
                              child:
                              Text(
                                'Tambah Barang', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.black),
                              ),
                            )
                        ),

                        SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        Text('Kode Toko',
                          style: TextStyle(color: Color.fromARGB(255, 255, 17, 17), ),
                        ),
                        TextField(
                          controller: kode_toko,
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kode Lokasi',
                              style: TextStyle(color: Color.fromARGB(255, 255, 17, 17), ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              // width: 300,
                              // height: 40,
                              child:
                              MaterialButton(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  color: Color.fromARGB(255, 255, 17, 17),
                                  onPressed: () => scanBarcode2(),
                                  child:
                                  Text('Scan',
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                  )
                              ),
                            ),
                          ],
                        ),

                        TextField(
                          controller: kode_lokasi!..text = '$_scanBarcode2\n',
                        ),

                        SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('No. SKU',
                              style: TextStyle(color: Color.fromARGB(255, 255, 17, 17), ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              // width: 300,
                              // height: 40,
                              child:
                              MaterialButton(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  color: Color.fromARGB(255, 255, 17, 17),
                                  onPressed: () => scanBarcode(),
                                  child:
                                  Text('Scan',
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                  )
                              ),
                            ),
                          ],
                        ),

                        TextField(
                          controller: sku!..text = '$_scanBarcode\n',
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        Text('Quantity',
                          style: TextStyle(color: Color.fromARGB(255, 255, 17, 17), ),
                        ),
                        TextField(
                          controller: qty,
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        Text('Tanggal',
                          style: TextStyle(color: Color.fromARGB(255, 255, 17, 17), ),
                        ),
                        TextField(
                            controller: date,
                            decoration: InputDecoration(
                              // icon: Icon(Icons.calendar_today), //icon of text field
                              // labelText: "Enter Date" //label text of field
                            ),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  date!.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            }
                        ),

                        Container(

                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 17, 17),
                            //  borderRadius: BorderRadius.circular(20)

                          ),

                          child:

                          TextButton(child:
                          Text('Submit',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),

                          ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      'Validation Successful',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                                upsertActivityy();
                              }
                              DateTime now = new DateTime.now();
                            },
                          ),
                        )
                      ],
                    ),
                  )
              )

            ]
        )


    );
  }

  Future<void> upsertActivityy() async {
    if (widget.pdt != null) {
      //update
      await db.updateRamayanaModel(RamayanaModel.fromMap({
        'id_act': widget.pdt!.id_act,
        'kode_toko': kode_toko!.text,
        'kode_lokasi': kode_lokasi!.text,
        'sku': sku!.text,
        'quantity': qty!.text,
        'date': date!.text,
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.savePdt(RamayanaModel(
        kode_toko: kode_toko!.text,
        kode_lokasi: kode_lokasi!.text,
        sku: sku!.text,
        qty: qty!.text,
        date: date!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }

}