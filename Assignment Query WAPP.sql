INSERT INTO CourseTable (CourseID, Level, Title) VALUES
('C001', 'Beginner', 'Beginner Korean'),
('C002', 'Intermediate', 'Intermediate Korean'),
('C003', 'Advanced', 'Advanced Korean');

INSERT INTO lessonTable(lessonID, courseID, instructorID, type, content) VALUES
('L001', 'C001', 'U002', 'Hangul',
'Introduction to Hangul: Learn the basic Korean consonants ㄱ, ㄴ, ㄷ, ㄹ, ㅁ and vowels ㅏ, ㅑ, ㅓ, ㅕ, ㅗ.'),

('L002', 'C001', 'U002', 'Hangul',
'Reading syllable blocks: Combine consonants and vowels to read 가, 나, 다, 라, 마.'),

('L003', 'C001', 'U011', 'Vocabulary',
'Korean greetings: 안녕하세요 (hello), 감사합니다 (thank you), 죄송합니다 (sorry), 안녕히 가세요 (goodbye).'),

('L004', 'C001', 'U011', 'Grammar',
'Topic marker 은/는: Use 은 after a consonant and 는 after a vowel. Example: 저는 학생입니다.'),

('L005', 'C002', 'U012', 'Vocabulary',
'Daily routine vocabulary: 일어나다 (wake up), 먹다 (eat), 공부하다 (study), 자다 (sleep).'),

('L006', 'C002', 'U012', 'Grammar',
'Present tense -아요/어요: 먹다 becomes 먹어요, and 공부하다 becomes 공부해요.'),

('L007', 'C003', 'U011', 'Grammar',
'Korean honorific requests: Use -(으)세요. Example: 앉으세요 means Please sit.');


INSERT INTO forumTable
(ForumID, studentID, lecturerID, questionText, questionDate,
responseText, responseDate, stat)
VALUES
('F001', 'U001', 'U002',
'Why does ㄱ sometimes sound like g and sometimes k?',
'2026-03-02 09:15:00',
'At the beginning of a word ㄱ often sounds closer to g. At the end of a word it sounds like k.',
'2026-03-02 14:10:00', 'Answered'),

('F002', 'U006', 'U002',
'How do I know where to place the vowel in a Korean syllable block?',
'2026-03-04 10:30:00',
NULL, NULL, 'Open'),

('F003', 'U007', 'U011',
'What is the difference between 안녕 and 안녕하세요?',
'2026-03-06 12:00:00',
'안녕 is casual for close friends. 안녕하세요 is polite and suitable for teachers and new people.',
'2026-03-06 16:20:00', 'Answered'),

('F004', 'U008', 'U011',
'Why is it 저는 instead of 저은?',
'2026-03-09 08:45:00',
'저 ends with a vowel, so use 는. 은 is used after a final consonant, for example 학생은.',
'2026-03-09 11:30:00', 'Answered'),

('F005', 'U009', 'U002',
'Can you give more examples of verbs ending with 하다?',
'2026-03-13 15:10:00',
NULL, NULL, 'Open'),

('F006', 'U010', 'U011',
'Is -(으)세요 always required when speaking to older people?',
'2026-03-16 13:20:00',
'It is a common polite form for requests and instructions, but the correct form depends on the relationship and situation.',
'2026-03-16 17:00:00', 'Answered');

SELECT * FROM LessonTable;
SELECT * FROM ForumTable;