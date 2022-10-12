class RamayanaModel {
    int? id_act;
    String? sku;
    String? kode_lokasi;
    String? kode_toko;
    String? qty;
    String? date;

    RamayanaModel({
      this.sku,
      this.kode_lokasi,
      this.kode_toko,
      this.qty,
      this.date
    });

    Map<String, dynamic> toMap() {
      var map = Map<String, dynamic>();

      if (id_act != null) {
        map['id_act'] = id_act;
      }
      map['sku'] = sku;
      map['kode_lokasi'] = kode_lokasi;
      map['kode_toko'] = kode_toko;
      map['qty'] = qty;
      map['date'] = date;

      return map;
    }

    RamayanaModel.fromMap(Map<String, dynamic> map) {
      this.id_act = map['id_act'];
      this.sku = map['sku'];
      this.kode_lokasi = map['kode_lokasi'];
      this.kode_toko = map['kode_toko'];
      this.qty = map['qty'];
      this.date = map['date'];
    }
}