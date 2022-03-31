import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class download_db{
    download_db._init();
    static final download_db instance =download_db._init();

    static Database ? _database;

    Future _createDB(Database db ,int version)async{
    await db.execute('''CREATE TABLE Downloads(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      date TEXT,
      path TEXT,
      classid TEXT,
      userid TEXT
      )''');
    }

    Future _initDB(String filepath)async{
    final db_path =await getDatabasesPath();
    final path = join(db_path,filepath);
    return await openDatabase(path,version: 1,onCreate: _createDB);
    }
    Future get database async{
    if(_database!=null){
    return _database;
    }
    _database=await _initDB('Quizzy_db.db');
    return _database;
    }
    Future adddata(String title,String Date,String path,String uid,String cid)async{
      var db =await instance.database;
      await db.execute('''
    INSERT INTO Downloads (title,date,path,classid,userid) VALUES ('$title','$Date','$path','$cid','$uid')
    ''');
    }
    Future get()async{
        Database db =await instance.database;
        return await  db.rawQuery('SELECT * FROM Downloads');
    }
    Future getall(String uid,String cid)async{
      Database db =await instance.database;
      return await  db.query('Downloads',where: 'classid = ? AND userid =?',whereArgs:[cid,uid]);
    }
    Future deleteitem(int id)async{
        Database db =await instance.database;
        await db.execute('DELETE FROM Downloads WHERE id = $id');
    }
  }
