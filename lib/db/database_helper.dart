import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/price_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('comp_price.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE products (
  barcode $textType PRIMARY KEY,
  name $textType
)
''');

    await db.execute('''
CREATE TABLE prices (
  id $idType,
  barcode $textType,
  store $textType,
  price $realType,
  date $textType,
  FOREIGN KEY (barcode) REFERENCES products (barcode)
)
''');
  }

  Future<void> createProduct(Product product) async {
    final db = await instance.database;
    await db.insert('products', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Product?> readProduct(String barcode) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      columns: ['barcode', 'name'],
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> createPriceEntry(PriceEntry entry) async {
    final db = await instance.database;
    await db.insert('prices', entry.toMap());
  }

  Future<List<PriceEntry>> readPriceEntries(String barcode) async {
    final db = await instance.database;
    final result = await db.query(
      'prices',
      where: 'barcode = ?',
      whereArgs: [barcode],
      orderBy: 'date DESC',
    );

    return result.map((json) => PriceEntry.fromMap(json)).toList();
  }

  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');

    return result.map((json) => Product.fromMap(json)).toList();
  }
}
