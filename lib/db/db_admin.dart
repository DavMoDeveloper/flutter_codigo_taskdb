import 'dart:io';

import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;

  //Singleton
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase(); // Crear base de datos
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskBD.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database dbx, int version) async {
        //Crear la tabla correspondiente
        await dbx.execute(
            "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT, description TEXT, status TEXT)");
      },
    );
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) values('${model.title}','${model.description}','${model.status}')");
    return res;
  }

  Future<int> instertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "TASK",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    return res;
  }

  getRawTask() async {
    Database? db = await checkDatabase();
    List task = await db!.rawQuery("SELECT * FROM Task");
    print(task);
  }

  Future<List<TaskModel>> getTask() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> task = await db!.query("Task");
    List<TaskModel> taskModelList = task.map((e) => TaskModel.mapToModel(e)).toList();

    // task.forEach((element) { 
    //   TaskModel task = TaskModel.mapToModel(element);
    //   taskModelList.add(task);
    // });
    return taskModelList;
  }

  Future<int> updateRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        "UPDATE TASK SET title = ${model.title}, description = ${model.description}, status = ${model.status} WHERE id = ${model.id}");
    return res;
  }

  Future<int> updateTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.update(
      "TASK",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
      where: "id = ${model.id}"
    );
    return res;
  }

  Future<int> deleteRawTask(int id) async {
    Database? db = await checkDatabase();
    int res =  await db!.rawDelete("DELETE FROM TASK WHERE id = $id");
    return res;
  }

  Future<int> deleteTask(int id) async {
    Database? db = await checkDatabase();
    int res =  await db!.delete("TASK", where: "id = $id");
    return res;
  }
}
