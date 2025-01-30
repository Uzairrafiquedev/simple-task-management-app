
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_management_app/services/database_service.dart';

import '../model/todo_model.dart';

class PendingWidgets extends StatefulWidget {
  const PendingWidgets({super.key});

  @override
  State<PendingWidgets> createState() => _PendingWidgetsState();
}

class _PendingWidgetsState extends State<PendingWidgets> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(stream: _databaseService.todos, builder: (context,snapshot){
      if(snapshot.hasData){
        List<Todo> todos = snapshot.data!;
        return ListView.builder(
          itemBuilder: (context,index){
            Todo todo = todos[index];
            final DateTime dt = todo.timeStamp.toDate();
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Slidable(
                endActionPane: ActionPane(motion: DrawerMotion(), children: [
                  SlidableAction(
                    backgroundColor: Colors.green,
                      icon: Icons.done,
                      label: "Mark as done",
                      onPressed: (context){
                    _databaseService.updateTodoStatus(todo.id, true);
                  })
                ]),
                startActionPane: ActionPane(motion: DrawerMotion(), children: [
                  SlidableAction(
                      backgroundColor: Colors.redAccent,
                      icon: Icons.edit,
                      label: "Edit",
                      onPressed: (context){
                        _showTaskDialog(context,todo: todo);
                      }),
                  SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: "Delete",
                      onPressed: (context)async{
                        await _databaseService.deleteTodoTask(todo.id);
                      }),
                ]),
                child: ListTile(
                title: Text(todo.title,),
                subtitle: Text(todo.description,),
                trailing: Text('${dt.day}/${dt.month}.${dt.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              key: ValueKey(todo.id),),
            );
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: todos.length,
        );
      }else{
        return Center(child: CircularProgressIndicator(),);
      }
    });
  }
  void _showTaskDialog(BuildContext context,{Todo? todo}){
    final TextEditingController _titleController = TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController = TextEditingController(text: todo?.description);
    final DatabaseService _databaseService = DatabaseService();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(todo == null ?"Add Task":"Edit Task"),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              spacing: 20,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(

                      )
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(

                      )
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),
          ),
          ElevatedButton(onPressed: ()async{
            if(todo==null){
              await _databaseService.addTodoTask(_titleController.text, _descriptionController.text);
            }
            else{
              await _databaseService.updateTodo(todo.id, _titleController.text, _descriptionController.text);
            }
            Navigator.pop(context);
          }, child: Text(todo == null ? "Add": "Update"))
        ],
      );
    });
  }
}
