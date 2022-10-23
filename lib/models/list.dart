class ListModel {
  int? id;
  String title;
  int creator;

  ListModel({this.id, required this.title, required this.creator});

  Map<String, dynamic> toMap() {
    return {'name': title, 'userId': creator};
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(id: map['id'], title: map['name'], creator: map['userId']);
  }
}
