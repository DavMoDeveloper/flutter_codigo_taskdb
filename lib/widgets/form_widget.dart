import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskdb/db/db_admin.dart';
import 'package:flutter_codigo_taskdb/models/task_model.dart';

class FormWidget extends StatefulWidget {
  TaskModel? taskModel;
  FormWidget({
    this.taskModel,
  });
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.taskModel != null) {
      _id = widget.taskModel!.id;
      _title = widget.taskModel!.title;
      _description = widget.taskModel!.description;
      _isEdit = _id!=null ? true:false;
      _titleControler.text = _title.toString();
      _descritionControler.text = _description.toString();
      _isFinished = widget.taskModel!.status == "true" ? true : false;
    }
    super.initState();
  }

  final _forKey = GlobalKey<FormState>();

  int? _id;
  String? _title;
  String? _description;
  bool _isFinished = false;
  bool _isEdit = false;

  final TextEditingController _titleControler = TextEditingController();
  final TextEditingController _descritionControler = TextEditingController();

  addTask() {
    if (_forKey.currentState!.validate()) {
      TaskModel model = TaskModel(
          title: _titleControler.text,
          description: _descritionControler.text,
          status: _isFinished.toString());
      DBAdmin.db.instertTask(model).then((value) {
        if (value > 0) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(milliseconds: 1400),
                content: Row(
                  children: const [
                    Icon(Icons.check_circle),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Tarea registrada con exito"),
                  ],
                )),
          );
        }
      });
    }
  }

  editTask() {
    if (_forKey.currentState!.validate()) {
      TaskModel model = TaskModel(
        id: _id,
        title: _titleControler.text,
        description: _descritionControler.text,
        status: _isFinished.toString(),
      );
      DBAdmin.db.updateTask(model).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              duration: const Duration(milliseconds: 1400),
              content: Row(
                children: const [
                  Icon(Icons.check_circle),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("Tarea editada con exito"),
                ],
              )),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _forKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isEdit == false? Text("Agregar tarea"):Text("Editar tarea"),
            SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleControler,
              decoration: InputDecoration(hintText: "Título"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                if (value.length < 6) {
                  return "Debe tener min 6 caracters";
                }
                return null;
              },
            ),
            SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _descritionControler,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Descripción"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                Text("Estado"),
                SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                  value: _isFinished,
                  onChanged: (value) {
                    _isFinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                _isEdit == false? ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text("Aceptar"),
                ):ElevatedButton(
                  onPressed: () {
                    editTask();
                  },
                  child: Text("Editar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
