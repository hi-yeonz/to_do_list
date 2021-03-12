//lib > DB > Model.dart

class Todo {
  int id;
  String todo;
  String type;
  bool complete;

  Todo({
    this.id,
    this.todo,
    this.type,
    this.complete,
  });

  // Map 형식의 데이터를 Json 으로 바꿔줌
  factory Todo.fromJson(Map<String, dynamic> json) => new Todo(
        id: json["id"],
        todo: json["todo"],
        type: json["type"],
        complete: json["complete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "type": type,
        "complete": complete,
      };
}
