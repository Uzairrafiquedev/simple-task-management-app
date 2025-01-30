
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_management_app/services/database_service.dart';

import '../model/todo_model.dart';

class CompletedWidgets extends StatefulWidget {
  const CompletedWidgets({super.key});

  @override
  State<CompletedWidgets> createState() => _CompletedWidgets();
}

class _CompletedWidgets extends State<CompletedWidgets> {
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
    return StreamBuilder<List<Todo>>(stream: _databaseService.competedtodos, builder: (context,snapshot){
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
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: "Delete",
                      onPressed: (context)async{
                        await _databaseService.deleteTodoTask(todo.id);
                      }),
                ]),

                child: ListTile(
                  title: Text(todo.title,style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),),
                  subtitle: Text(todo.description,style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),),
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
}
