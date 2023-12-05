import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqlite/dog.dart';

class DogDatabase {
  Future<Database> openDogDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), "doggie_database.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await openDogDatabase();
    await db.insert(
      "dogs",
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    final db = await openDogDatabase();
    final List<Map<String, dynamic>> maps = await db.query("dogs");

    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]["id"] as int,
        name: maps[i]["name"] as String,
        age: maps[i]["age"] as int,
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    final db = await openDogDatabase();
    await db.update(
      "dogs",
      dog.toMap(),
      where: "id = ?",
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog() async {
    final db = await openDogDatabase();
    await db.delete(
      "dogs",
    );
  }

  Future<void> deleteDogById(int id) async {
    final db = await openDogDatabase();
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
  
}

