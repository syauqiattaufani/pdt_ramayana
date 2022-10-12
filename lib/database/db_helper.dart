import 'package:pdt_ramayana/models/RamayanaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String tableName = 'tablePdt';
  final String columnIdAct = 'id_act';
  final String columnSku = 'sku';
  final String columnKodeLokasi = 'kode_lokasi';
  final String columnKodeToko = 'kode_toko';
  final String columnQty = 'qty';
  final String columnDate = 'date';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek apakah database ada
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'ramayanaPdt.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnIdAct INTEGER PRIMARY KEY, "
        "$columnSku TEXT,"
        "$columnKodeLokasi,"
        "$columnKodeToko,"
        "$columnQty,"
        "$columnDate)";
    await db.execute(sql);
  }

  //insert ke database
  Future<int> savePdt(RamayanaModel pdt) async {
      var dbClient = await _db;
      return await dbClient!.insert(tableName, pdt.toMap());
  }

  //read database
  Future<List?> getAllRamayanaModel() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName, columns: [
      columnIdAct,
      columnSku,
      columnKodeLokasi,
      columnKodeToko,
      columnQty,
      columnDate
    ]);

    return result.toList();
  }

  //update database
  Future<int?> updateRamayanaModel(RamayanaModel pdt) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, pdt.toMap(),
        where: '$columnIdAct = ?', whereArgs: [pdt.id_act]);
  }

  //hapus database
  Future<int?> deleteRamayanaModel(int id_act) async {
    var dbClient = await _db;
    return await dbClient!.delete(tableName, where: '$columnIdAct = ?', whereArgs: [id_act]);
  }
}