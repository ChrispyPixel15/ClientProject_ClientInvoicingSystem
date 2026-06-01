class TimesheetTask {
  final int? id;
  final String taskFK;
  final String posFK;
  final String clientFK;
  final String date;
  final String hours;
  final String invoiced;

  TimesheetTask({
    this.id,
    required this.taskFK,
    required this.posFK,
    required this.clientFK,
    required this.date,
    required this.hours,
    required this.invoiced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_fk': taskFK,
      'pos_fk': posFK,
      'client_fk': clientFK,
      'date': date,
      'hours': hours,
      'invoiced': invoiced,
    };
  }

  factory TimesheetTask.fromMap(Map<String, dynamic> map) {
    return TimesheetTask(
      id: map['id'],
      taskFK: map['task_fk'],
      posFK: map['pos_fk'],
      clientFK: map['client_fk'],
      date: map['date'],
      hours: map['hours'],
      invoiced: map['invoiced'],
    );
  }
}