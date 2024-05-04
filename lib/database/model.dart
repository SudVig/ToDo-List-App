class task {
  late int? id;
  late String title;
  late String description;
  late String? status = "no";

  task(
      {this.id,
      required this.title,
      required this.description,
      this.status = "no"});

  Map<String, dynamic> mapping() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['status'] = status;
    return map;
  }
}
