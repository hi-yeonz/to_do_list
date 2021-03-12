import 'package:flutter/material.dart';
import 'dart:math';
import 'DB/Model.dart';
import 'bloc.dart';

// 랜덤으로 들어 갈 데이터
List<Todo> todoData = [
  Todo(todo: '오늘은 무슨일을 할까', type: 'TALK', complete: false),
  Todo(todo: '내일은 무슨일을 할까', type: 'MEET', complete: true),
  Todo(todo: '모레는 무슨일을 할까', type: 'DATE', complete: false),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalStorageExample',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //BLoc 가져옴
  final TodoBloc bloc = TodoBloc();

  // Stateful Widget 이 dispose 될때 스트림을 닫는다.
  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOCAL CRUD'),
      ),
      body: StreamBuilder(
        stream: bloc.todos,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          // 데이터의 유무를 확인한다
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Todo item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // 이제 Bloc 을 이용하여 명령을 수행합니다.
                        bloc.deleteTodo(item.id);
                      },
                      child: ListTile(
                        title: Text(item.todo),
                        leading: Text(
                          item.id.toString(),
                        ),
                        trailing: Checkbox(
                          onChanged: (bool value) {
                            // 이제 Bloc 을 이용하여 명령을 수행합니다.
                            bloc.updateTodo(item);
                          },
                          value: item.complete,
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Center(
                    child: Text('No data'),
                  ),
                );
        },
      ),

      // 전체 삭제와 TODO 추가를 위한 FloatingActionButton
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Todo newTodo = todoData[Random().nextInt(todoData.length)];
                // 이제 Bloc 을 이용하여 명령을 수행합니다.
                bloc.addTodos(newTodo);
              },
            ),

            SizedBox(
              height: 16.0,
            ),

            FloatingActionButton(
              child: Icon(Icons.delete_forever),
              onPressed: () {
                // 이제 Bloc 을 이용하여 명령을 수행합니다.
                bloc.deleteAll();
              },
            ),

          ],
        ),
      ),
    );
  }
}
