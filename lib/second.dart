import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Todo{       //할일 정보를 저장할 Todo 클래스
  bool isDone;
  String title;

  Todo(this.title,{this.isDone = false});   //isDone 기본값 false로 설정
}


class Second extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: TodoListPage(),   //TodoListPage라는 statefulWidget
    );
  }
}

class TodoListPage extends StatefulWidget{
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>{

  var _todoController = TextEditingController();    //컨트롤러 -> 사용자의 요청을 처리 한 후 지정된 view에 모델 객체를 넘겨주는 역할


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
                  child: TextField(                 //TextField : 메세지를 입력할 수 있는 위젯
                    controller: _todoController,    //view와 매핑되도록
                  ),
                ),
                ElevatedButton(
                  child: Text("추가"),
                  onPressed: () => _addTodo(Todo(_todoController.text)),  //버튼 클릭이벤트 : textflied에 있는 내용 add()
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(     //값이 자주 바뀌는 경우(화면 업데이트 자주 일어나는 경우) -> 전체화면을 새로 로딩하는게 아니라 이부분만 새로 로딩됨
                stream: FirebaseFirestore.instance.collection('todolist').snapshots(),    //현재 firebase의 'todolist'컬렉션의 내용 가져옴
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }

                  final documents = snapshot.data!.docs;
                  return Expanded(
                    child: ListView(    //listview(여러 할일정보를 리스트로 보이게 위젯
                      children: documents.map((doc) => _buildItemWidget(doc)).toList(), //document의 내용 list로 만들어 listView로 보이게 함
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
    final todo = Todo(doc['title'],isDone: doc['isDone']);  //위에서 정의한 Todo클래스 객체 생성
    return ListTile(
      onTap: () => _toggleTodo(doc),
      title: Text(
          todo.title,
          style: todo.isDone
              ? TextStyle(decoration: TextDecoration.lineThrough,  //isDone = false이면
              fontStyle: FontStyle.italic)
              :null   //isDone = true이면
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),   //삭제 버튼을 눌렀을 때
        onPressed: () => _deleteTodo(doc),
      ),
    );
  }

  void _addTodo(Todo todo){
    FirebaseFirestore.instance
        .collection('todolist').add({'title':todo.title, 'isDone':todo.isDone});    //todo객체의 내용 firebase에 저장
    _todoController.text = '';      //textField에 썼던 내용 없애기(초기화)
  }
  void _deleteTodo(DocumentSnapshot doc){
    FirebaseFirestore.instance
        .collection('todolist').doc(doc.id).delete();     //삭제
  }
  void _toggleTodo(DocumentSnapshot doc){
    FirebaseFirestore.instance
        .collection('todolist').doc(doc.id).update({    //업데이트 (isDone의 값을 반대로 바꿈)
      'isDone': !doc['isDone'],
    });
  }

}