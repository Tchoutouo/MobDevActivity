class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPinned: isPinned ?? this.isPinned,
  );

  factory Note.fromMap(Map<String, dynamic> m) => Note(
    id: m['id'] as int?,
    title: m['title'] as String,
    content: m['content'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(m['updatedAt'] as int),
    isPinned: (m['isPinned'] as int) == 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'isPinned': isPinned ? 1 : 0,
  };
}
