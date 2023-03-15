class Todo {
  final DateTime notificationDate;
  final String title;
  final String description;
  final String category;
  bool isDone;
  Todo({
    required this.title,
    required this.description,
    required this.notificationDate,
    required this.category,
    this.isDone = false,
  });
  
  

}
