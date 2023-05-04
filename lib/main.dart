import 'package:firebase_core/firebase_core.dart';
import 'package:first_prj/second.dart';
import 'package:flutter/material.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Home()
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/elmo.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Text("권수현",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Jalnan',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Flutter developer",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                fontFamily: 'Jalnan',
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: 200,
              child: Divider(
                color: Colors.white70,
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              color: Colors.white,
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>
                        Second()),
                  );
                },
                leading: Icon(Icons.phone, color: Colors.deepOrangeAccent,),
                title: Text("010-4767-4396",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Jalnan',
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.mail, color: Colors.deepOrangeAccent,),
                title: Text("kwonsh4396@gmail.com",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Jalnan',
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              color: Colors.white,
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>
                        Second()),
                  );
                },
                leading: Icon(Icons.calendar_month_outlined, color: Colors.deepOrangeAccent,),
                title: Text("2023-05-04",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Jalnan',
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ),

          ],
        ),
    );
  }
}
