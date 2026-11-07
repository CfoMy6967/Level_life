/// Represents one repeatable daily "Quest".
class DailyTask {
  final String id;
  final String icon;
  final String title;
  final String description;
  final int xpReward;
  final String category; // Discipline, Learning, Body, Skill/Project
  final String? skillId; // optional link to a SkillXp.name
  bool isEnabled;
  bool isCompleted;

  DailyTask({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.category,
    this.skillId,
    this.isEnabled = true,
    this.isCompleted = false,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      icon: json['icon'],
      title: json['title'],
      description: json['description'],
      xpReward: json['xpReward'],
      category: json['category'],
      skillId: json['skillId'],
      isEnabled: json['isEnabled'] ?? true,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon,
        'title': title,
        'description': description,
        'xpReward': xpReward,
        'category': category,
        'skillId': skillId,
        'isEnabled': isEnabled,
        'isCompleted': isCompleted,
      };

  DailyTask copyWith({
    String? title,
    String? description,
    int? xpReward,
    bool? isEnabled,
    bool? isCompleted,
  }) {
    return DailyTask(
      id: id,
      icon: icon,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      category: category,
      skillId: skillId,
      isEnabled: isEnabled ?? this.isEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// The default set of daily quests used the first time the app runs.
/// Editable later from the Settings screen.
List<DailyTask> defaultDailyTasks() {
  return [
    DailyTask(id: 't1', icon: '🌅', title: 'ตื่นเช้า', description: 'เริ่มต้นวันให้ตรงเวลา', xpReward: 10, category: 'Discipline', skillId: 'Discipline'),
    DailyTask(id: 't2', icon: '📚', title: 'ตั้งใจเรียน', description: 'ตั้งใจฟังและเก็บเนื้อหาในห้องเรียน', xpReward: 20, category: 'Learning', skillId: 'Study'),
    DailyTask(id: 't3', icon: '🍳', title: 'กินข้าวเช้า', description: 'เติมพลังงานให้ร่างกายตอนเช้า', xpReward: 5, category: 'Body', skillId: 'Fitness'),
    DailyTask(id: 't4', icon: '🍱', title: 'กินข้าวกลางวัน', description: 'ทานอาหารกลางวันให้ครบมื้อ', xpReward: 5, category: 'Body', skillId: 'Fitness'),
    DailyTask(id: 't5', icon: '🍛', title: 'กินข้าวเย็น', description: 'ทานอาหารเย็นให้ครบมื้อ', xpReward: 5, category: 'Body', skillId: 'Fitness'),
    DailyTask(id: 't6', icon: '💻', title: 'อ่านโค้ด 1 ชม.', description: 'ฝึกอ่าน/ทำความเข้าใจโค้ด 1 ชั่วโมง', xpReward: 25, category: 'Skill/Project', skillId: 'Coding'),
    DailyTask(id: 't7', icon: '⚖️', title: 'อ่านกฎหมาย 1 ชม.', description: 'อ่านและทำความเข้าใจตัวบทกฎหมาย 1 ชั่วโมง', xpReward: 25, category: 'Learning', skillId: 'Law'),
    DailyTask(id: 't8', icon: '🚫', title: 'งด...', description: 'งดสิ่งที่ไม่ควรทำตามที่ตั้งใจไว้', xpReward: 50, category: 'Discipline', skillId: 'Discipline'),
    DailyTask(id: 't9', icon: '🔄', title: 'ทบทวน', description: 'ทบทวนเนื้อหาที่เรียนมา', xpReward: 35, category: 'Learning', skillId: 'Study'),
    DailyTask(id: 't10', icon: '📖', title: 'อ่านก่อนเรียน', description: 'เตรียมเนื้อหาล่วงหน้าก่อนเข้าเรียน', xpReward: 30, category: 'Learning', skillId: 'Study'),
    DailyTask(id: 't11', icon: '📝', title: 'ทำการบ้าน', description: 'ทำการบ้าน/แบบฝึกหัดที่ได้รับมอบหมาย', xpReward: 20, category: 'Learning', skillId: 'Study'),
    DailyTask(id: 't12', icon: '🏋️', title: 'ออกกำลังกาย', description: 'ดูแลร่างกายให้แข็งแรง', xpReward: 20, category: 'Body', skillId: 'Fitness'),
    DailyTask(id: 't13', icon: '🌙', title: 'นอนตรงเวลา', description: 'เข้านอนตามเวลาที่ตั้งใจไว้', xpReward: 15, category: 'Discipline', skillId: 'Discipline'),
    DailyTask(id: 't14', icon: '🔎', title: 'ค้นคว้า/อ่านหนังสืออื่น ๆ', description: 'อ่านหรือค้นคว้าความรู้เพิ่มเติมนอกบทเรียน', xpReward: 30, category: 'Learning', skillId: 'Study'),
    DailyTask(id: 't15', icon: '🇬🇧', title: 'ฝึกอังกฤษ', description: 'ฝึกฟัง พูด อ่าน เขียนภาษาอังกฤษ', xpReward: 20, category: 'Learning', skillId: 'English'),
    DailyTask(id: 't16', icon: '🇨🇳', title: 'ฝึกจีน', description: 'ฝึกฟัง พูด อ่าน เขียนภาษาจีน', xpReward: 30, category: 'Learning', skillId: 'Chinese'),
    DailyTask(id: 't17', icon: '📊', title: 'อ่านและวิเคราะห์กราฟ', description: 'ฝึกอ่านและวิเคราะห์กราฟ', xpReward: 30, category: 'Skill/Project', skillId: 'Trading'),
  ];
}
