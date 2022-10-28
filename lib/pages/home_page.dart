import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskdb/db/db_admin.dart';
import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:flutter_codigo_taskdb/widgets/form_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async {
    return "Juan Manuel";
  }

  showDialogForm(TaskModel? taskModel) {
    showDialog(
      context: context,
      builder: (BuildContext context,) {
        return FormWidget(taskModel: taskModel,);
      },
    ).then((value) {
      setState(() {});
    });
  }

  deleteTask(int id) {
    DBAdmin.db.deleteTask(id).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo,
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Tarea eliminada"),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogForm(null);
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: DBAdmin.db.getTask(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<TaskModel> myTasks = snapshot.data;
              return ListView.builder(
                itemCount: myTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (DismissDirection direction) async {
                      print(direction);
                      return true;
                    },
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.redAccent,
                    ),
                    //secondaryBackground: Text("HOla2"),
                    onDismissed: (DismissDirection direction) {
                      deleteTask(myTasks[index].id!);
                    },
                    child: ListTile(
                      title: Text(myTasks[index].title),
                      subtitle: Text(myTasks[index].description),
                      trailing: IconButton(icon: Icon(Icons.edit),onPressed: () {
                        showDialogForm(myTasks[index]);
                      },),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
