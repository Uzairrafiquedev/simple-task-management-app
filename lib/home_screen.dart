import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/login_screen.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/services/database_service.dart';
import 'package:task_management_app/widgets/completed_widgets.dart';
import 'package:task_management_app/widgets/pending_widgets.dart';

import 'model/todo_model.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen>{

  int _buttonIndex=0;
  final _widgets =[
    PendingWidgets(),
    CompletedWidgets()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        actions: [
          IconButton(onPressed: ()async{
            await AuthService().signout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: (){
                setState(() {
                  _buttonIndex = 0;
                });
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2.2,
                decoration: BoxDecoration(
                  color: _buttonIndex == 0? Colors.blueGrey:Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Pending",style: TextStyle(
                    fontSize: _buttonIndex == 0 ? 16:14,
                    fontWeight: FontWeight.bold,
                    color: _buttonIndex == 0 ? Colors.red:Colors.redAccent,
                  ),),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: (){
                setState(() {
                  _buttonIndex = 1;
                });
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2.2,
                decoration: BoxDecoration(
                  color: _buttonIndex == 0? Colors.blueGrey:Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Completed",style: TextStyle(
                    fontSize: _buttonIndex == 1 ? 16:14,
                    fontWeight: FontWeight.bold,
                    color: _buttonIndex == 1 ? Colors.red:Colors.redAccent,
                  ),),
                ),
              ),
            ),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showTaskDialog(context);
          },
        child: Icon(Icons.add),
      ),
    );
  }
  void _showTaskDialog(BuildContext conext,{Todo? todo}){
    final TextEditingController _titleController = TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController = TextEditingController(text: todo?.description);
    final DatabaseService _databaseService = DatabaseService();
    
    showDialog(context: context, builder: (conext){
      return AlertDialog(
        title: Text(todo == null ?"Add Task":"Edit Task"),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
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