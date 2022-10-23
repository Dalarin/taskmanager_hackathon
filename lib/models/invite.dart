class Invite {
  int? id;
  int invited;
  int userId;
  int taskId;
  DateTime invitationDate;

  Invite({
    this.id,
    required this.invited,
    required this.taskId,
    required this.invitationDate,
    required this.userId,
  });

  Map<String, dynamic> toMap(int userId) {
    return {'taskId': taskId, 'userId': userId, 'invited': invited};
  }

  factory Invite.fromMap(Map<String, dynamic> map) {
    return Invite(
      invited: int.parse(map['invited']),
      taskId: map['taskId'],
      invitationDate: DateTime.now(),
      userId: map['userId'],
    );
  }
}
