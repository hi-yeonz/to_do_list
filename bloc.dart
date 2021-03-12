import 'dart:async';
import 'DB/Model.dart';
import 'DB/DB_helper.dart';

class TodoBloc {
  TodoBloc() {
    getTodos();
  }

  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  dispose() {
    _todoController.close();
  }

  getTodos() async {
    _todoController.sink.add(await DBHelper().getAllTodos());
  }

  addTodos(Todo todo) async {
    await DBHelper().createData(todo);
    getTodos();
  }

  deleteTodo(int id) async {
    await DBHelper().deleteTodo(id);
    getTodos();
  }

  deleteAll() async {
    await DBHelper().deleteAllTodos();
    getTodos();
  }

  updateTodo(Todo item) async {
    Todo updateData = Todo(
        complete: !item.complete,
        todo: item.todo,
        type: item.type,
        id: item.id);
    await DBHelper().updateTodo(updateData);
    getTodos();
  }
}
