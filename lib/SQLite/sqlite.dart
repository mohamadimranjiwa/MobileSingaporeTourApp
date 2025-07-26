import 'package:kuantan_tour_app/JsonModels/admin.dart';
import 'package:kuantan_tour_app/JsonModels/tourbook.dart';
import 'package:kuantan_tour_app/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "SingaporeDb.db";
  static const _databaseVersion = 1;

  static const tableAdmin = 'admin';
  static const tableUser = 'user';
  static const tableTourBooking = 'tourbooking';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // This opens the database (and creates it if it doesn't exist)
  Future _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAdmin (
        adminid INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableUser (
        userid INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableTourBooking (
        bookid INTEGER PRIMARY KEY,
        userid INTEGER,
        starttour TEXT NOT NULL,
        endtour TEXT NOT NULL,
        tourpackage TEXT NOT NULL,
        nopeople INTEGER,
        packageprice REAL
      )
    ''');

    // Insert hardcoded admin data during database creation
    await _AdminData(db);
  }

  // Insert hardcoded admin data during database initialization
  Future<void> _AdminData(Database db) async {
    // Hardcoded admin data
    Admin admin = Admin(
      username: 'admin',
      password: 'admin',
    );

    // Insert admin data into the database
    await db.insert(tableAdmin, admin.toMap());
  }

  // Login Method
  Future<bool> login(Users user) async {
    final Database db = await database;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is an admin
    var adminResult = await db.rawQuery(
        "SELECT * FROM $tableAdmin WHERE username = ?", [user.username]);
    if (adminResult.isNotEmpty) {
      // User is an admin, now check password
      var passwordResult = await db.rawQuery(
          "SELECT * FROM $tableAdmin WHERE username = ? AND password = ?",
          [user.username, user.password]);

      int userid = int.parse(
        passwordResult.first['adminid'].toString(),
      ); // Assuming 'id' is the column name for the user ID

      prefs.setInt('id', userid);
      return passwordResult.isNotEmpty;
    } else {
      // User is not an admin, check if the user exists in the user table
      var userResult = await db.rawQuery(
          "SELECT * FROM $tableUser WHERE username = ?", [user.username]);
      if (userResult.isNotEmpty) {
        // User exists, now check password
        var passwordResult = await db.rawQuery(
            "SELECT * FROM $tableUser WHERE username = ? AND password = ?",
            [user.username, user.password]);
        int userid = int.parse(
          passwordResult.first['userid'].toString(),
        ); // Assuming 'id' is the column name for the user ID

        prefs.setInt('id', userid);
        return passwordResult.isNotEmpty;
      } else {
        // User does not exist
        return false;
      }
    }
  }

  // Sign up
  Future<int> signup(Users user) async {
    final Database db = await database;
    return db.insert(tableUser, user.toMap());
  }

  // Get all users from the user table
  Future<List<Users>> getAllUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableUser);
    return List.generate(maps.length, (i) {
      return Users(
        userId: maps[i]['userid'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        phone: maps[i]['phone'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }

  // Insert tour booking data into the database
  Future<int> insertTourBooking(TourBooking tourBooking) async {
    final Database db = await database;
    return db.insert(tableTourBooking, tourBooking.toMap());
  }

  // Get all tour bookings from the tour booking table
  Future<List<TourBooking>> getUserTourBookings() async {
    final Database db = await database;
    final prefs = await SharedPreferences.getInstance();

    final userid = prefs.getInt('id');

    final List<Map<String, dynamic>> maps = await db.query(
      tableTourBooking,
      where: 'userid = ?',
      whereArgs: [userid],
    );

    // Use fromMap factory constructor to create instances from map data
    return List.generate(maps.length, (i) {
      return TourBooking.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getAllTourBookingsWithUserData() async {
    final Database db = await database;

    // Perform a JOIN operation between the 'tour_booking' and 'user' tables
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT $tableTourBooking.*, $tableUser.name, $tableUser.email, $tableUser.phone
    FROM $tableTourBooking
    INNER JOIN $tableUser ON $tableTourBooking.userid = $tableUser.userid
  ''');
    print(maps);

    return maps;
  }

  // Update a booking
  Future<int> updateBooking(TourBooking booking) async {
    final db = await database;
    return await db.update(
      'tourbooking',
      booking.toMap(),
      where: 'bookid = ?',
      whereArgs: [booking.bookId],
    );
  }

  // Delete a booking
  Future<int> deleteBooking(int bookId) async {
    final db = await database;
    return await db.delete(
      'tourbooking',
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }
}
