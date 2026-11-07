# Life Leveling (Prototype)

แอป Flutter สำหรับฝึกวินัยและพัฒนาทักษะผ่านระบบเก็บ XP และ Level แบบ RPG

## 1. ไฟล์ที่สร้าง และหน้าที่ของแต่ละไฟล์

```
life_leveling/
├── pubspec.yaml                  → ประกาศ dependency (flutter, shared_preferences)
└── lib/
    ├── main.dart                 → จุดเริ่มแอป + RootShell (bottom nav) + logic Daily Reset
    ├── models/
    │   ├── daily_task.dart       → โมเดล Quest รายวัน + รายการ Quest เริ่มต้น 11 อัน
    │   ├── skill.dart            → โมเดล Skill XP (Coding, Chinese, English, Fitness, Discipline)
    │   └── player.dart           → โมเดลผู้เล่น (Level, XP, Streak, ชื่อผู้ใช้, เป้าหมาย)
    ├── screens/
    │   ├── today_screen.dart     → หน้าหลัก แสดง Level Bar + Quest ทีละใบ
    │   ├── stats_screen.dart     → หน้าสถิติ (Total/Today/Week/Month XP, Streak)
    │   ├── skills_screen.dart    → หน้าแสดง XP แยกตาม Skill
    │   └── settings_screen.dart → ตั้งค่าชื่อผู้ใช้ เป้าหมาย และแก้ไข Quest
    ├── widgets/
    │   ├── level_bar.dart        → แถบ LEVEL + Progress Bar แบบ gradient
    │   ├── quest_card.dart       → การ์ด Quest พร้อม animation ตอนกด complete
    │   └── xp_animation.dart     → "+XP" ลอยขึ้น และ overlay ตอน Level Up
    ├── services/
    │   ├── xp_service.dart       → สูตรคำนวณ Level/XP ทั้งหมด (addXp, requiredXpForLevel)
    │   └── storage_service.dart  → บันทึก/โหลดข้อมูลถาวรด้วย SharedPreferences
    └── theme/
        └── app_theme.dart        → สีและธีม Dark RPG (แดง/ส้ม/แดงม่วง บนพื้นดำ)
```

## 2. Package ที่ต้องติดตั้ง

ระบุไว้ใน `pubspec.yaml` แล้ว มีเพียง 2 ตัวที่จำเป็นจริง ๆ:

- `shared_preferences` — สำหรับบันทึกข้อมูลถาวร (Level, XP, Quest, Skills, History)
- `cupertino_icons` — ไอคอนมาตรฐานของ Flutter (ติดมากับ template อยู่แล้ว)

ติดตั้งด้วยคำสั่ง:

```bash
flutter pub get
```

## 3. วิธีรันโปรเจกต์

```bash
cd life_leveling
flutter pub get
flutter run
```

รันบน emulator/อุปกรณ์จริงได้ตามปกติ (`flutter run -d chrome` ก็ใช้ได้ถ้าอยากลองบนเว็บ)

## 4. วิธีทดสอบระบบ XP และ Level Up

1. เปิดแอป จะเห็น `LEVEL 1` และ `0 / 125 XP`
2. กด Quest การ์ดใบแรก (เช่น "ตื่นตามเวลาที่กำหนด" +15 XP) → XP Bar ควรขยับ, มี "+15 XP" ลอยขึ้น, การ์ดหายแล้วใบถัดไปเลื่อนเข้ามา
3. กดต่อไปเรื่อย ๆ จนสะสม XP ครบ 125 → ระบบจะ:
   - เพิ่ม Level เป็น 2 อัตโนมัติ
   - XP ส่วนเกินจาก Level 1 จะถูกยกไปเป็น XP ของ Level 2 (ไม่มี XP หาย)
   - แสดง overlay "⚡ LEVEL UP ⚡" แบบ glow/scale
4. ปิดแอปแล้วเปิดใหม่ → Level, XP, Total XP ต้องยังอยู่เหมือนเดิม (ทดสอบ persistence)
5. ทดสอบ Daily Reset: เปลี่ยนวันที่ในเครื่อง (หรือรอข้ามวันจริง) แล้วเปิดแอปใหม่ → Quest ทุกใบต้องกลับมาให้ทำใหม่ แต่ **Level และ Total XP ต้องไม่ถูกรีเซ็ต**
6. ดูสถิติที่แท็บ 📊 Stats ว่า XP รายวัน/สัปดาห์/เดือน อัปเดตถูกต้อง

## 5. วิธีแก้ไข Daily Quest ในอนาคต

ไปที่แท็บ ⚙️ Settings แล้วภายใต้หัวข้อ "Daily Activities":

- แตะไอคอนดินสอ (✏️) ที่ Quest ใดก็ได้ เพื่อแก้ไข **ชื่อ, คำอธิบาย, จำนวน XP**
- ใช้สวิตช์ (Switch) เพื่อเปิด/ปิด Quest นั้นชั่วคราวโดยไม่ต้องลบ
- หากต้องการเพิ่ม Quest ใหม่ถาวร ให้แก้ในโค้ดที่ `lib/models/daily_task.dart` ฟังก์ชัน `defaultDailyTasks()` แล้วเพิ่ม `DailyTask(...)` รายการใหม่เข้าไปในลิสต์

## หมายเหตุ

- นี่คือ Prototype/MVP สำหรับทดลองระบบ Life Leveling เท่านั้น ไม่มีระบบการเงินใด ๆ ในเวอร์ชันนี้
- สูตร Level: `XPRequired(level) = 125 × 2^(level-1)` คำนวณด้วย bit-shift และมีการ clamp ระดับสูงสุดไว้เพื่อป้องกัน integer overflow
