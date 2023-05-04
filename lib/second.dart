import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Todo{
  bool isDone;
  String title;

  Todo(this.title,{this.isDone = false});
}


class Second extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget{
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>{

  var _todoController = TextEditingController();


  @override
  void dispose(){
    _todoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset : false,   //키보드에 밀려올라가지 않도록
      appBar: AppBar(title: Text("ToDo List"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,    //view와 매핑되도록
                  ),
                ),
                ElevatedButton(
                  child: Text("추가"),
                  onPressed: () => _addTodo(Todo(_todoController.text)),  //textfiled에 있는 내용 add()
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('todolist').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }

                  final documents = snapshot.data!.docs;
                  return Expanded(
                    child: ListView(
                      children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(DocumentSnapshot doc){
    final todo = Todo(doc['title'],isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleTodo(doc),
      title: Text(
          todo.title,
          style: todo.isDone
              ? TextStyle(decoration: TextDecoration.lineThrough,
              fontStyle: FontStyle.italic)
              :null
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(doc),
      ),
    );
  }

  void _addTodo(Todo todo){
    FirebaseFirestore.instance
        .collection('todolist').add({'title':todo.title, 'isDone':todo.isDone});
    _todoController.text = '';
  }
  void _deleteTodo(DocumentSnapshot doc){
    FirebaseFirestore.instance
        .collection('todolist').doc(doc.id).delete();
  }
  void _toggleTodo(DocumentSnapshot doc){
    FirebaseFirestore.instance
        .collection('todolist').doc(doc.id).update({
      'isDone': !doc['isDone'],
    });
  }

}