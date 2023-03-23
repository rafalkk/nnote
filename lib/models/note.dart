// ignore: empty_constructor_bodies
class Note {
  int? id;
  String title;
  String content;
  DateTime date;
  bool archived;
  bool notifyarea;

  Note({
    required this.title,
    required this.content,
    required this.date,
    this.archived = false,
    this.notifyarea = false,
    int? id,
  });

  Note.fromMap(Map<String, dynamic> map)
      : id = map["id"]!,
        title = map["title"]!,
        content = map["content"]!,
        date = DateTime.parse(map["date"]!),
        archived = map["archived"]! == 1,
        notifyarea = map["notifyarea"]! == 1;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();

    if (id != null) {
      data['id'] = id;
    }

    data['title'] = title;
    data['content'] = content;
    data['date'] = date.toIso8601String();
    archived == true ? data['archived'] = 1 : data['archived'] = 0;
    notifyarea == true ? data['notifyarea'] = 1 : data['notifyarea'] = 0;

    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'archived': archived,
      'notifyarea': notifyarea,
    }.toString();
  }
}
