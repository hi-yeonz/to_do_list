import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Model.dart';

final String tableName = 'todoExample';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();
  //기존 static 으로 지정된 변수는 private 으로 변경하고 factory 생성자를 사용하여 해당 변수를 리턴 시킵니다.
  //이제부터는 DBHelper().db 로 접근이 아닌 DBHelper() 로 접근이 가능합니다.
  //DB 에 접근하는 Helper 클래스를 만들었으니 테이블에 들어갈 모델 클래스를 간단하게 만들어 봅시다.

  factory DBHelper() => _db; //factory 생성자 : _db 변수 리턴

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database; //변수 또는 함수에 _ 를 붙이면 자동으로 private 상태로 인식

    _database = await initDB();
    return _database;
  }


  //데이터 초기화
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'superAwesomeDb.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            todo TEXT,
            type TEXT,
            complete BIT)
            '''
            );
      },
    );
  }

// CREATE
  createData(Todo todo) async {
    final db = await database;
    var res = await db.insert(tableName, todo.toJson());
    return res;
  }

// READ
  getTodo(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromJson(res.first) : Null;
  }

// READ ALL DATA
  getAllTodos() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Todo> list =
    res.isNotEmpty ? res.map((c) => Todo.fromJson(c)).toList() : [];
    return list;
  }

// Update Todo
  updateTodo(Todo todo) async {
    final db = await database;
    var res = await db
        .update(
        tableName, todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
    return res;
  }

// Delete Todo
  deleteTodo(int id) async {
    final db = await database;
    db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

// Delete All Todos
  deleteAllTodos() async {
    final db = await database;
    db.rawDelete('Delete from $tableName');
  }


}