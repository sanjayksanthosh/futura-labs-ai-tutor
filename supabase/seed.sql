-- Seed data for FuturaLabs Ai Tutor

-- Users
INSERT INTO users (id, name, email, avatar, role, institution, streak, total_courses, completed_lessons, ai_score, weekly_progress, last_active)
VALUES
  ('user_1', 'Alex Johnson', 'alex@example.com', 'https://i.pravatar.cc/150?u=alex', 'student', 'Tech University', 7, 5, 17, 78, 65, '2025-05-19T10:30:00.000Z'),
  ('user_2', 'Admin User', 'admin@example.com', 'https://i.pravatar.cc/150?u=admin', 'admin', 'FuturaLabs Ai Tutor', 30, 0, 0, 0, 0, '2025-05-19T14:00:00.000Z')
ON CONFLICT (id) DO NOTHING;

-- Courses
INSERT INTO courses (id, title, description, instructor, thumbnail, category, difficulty, progress, total_lessons, completed_lessons, duration_minutes, rating, student_count, is_bookmarked, prerequisites, created_at)
VALUES
  ('course_1', 'Machine Learning Fundamentals', 'Learn the core concepts of machine learning including supervised and unsupervised learning, neural networks, and model evaluation.', 'Dr. Sarah Chen', 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400', 'AI & Data Science', 'Intermediate', 45, 12, 5, 480, 4.8, 2341, true, ARRAY['Basic Programming', 'Statistics'], '2025-01-15T00:00:00.000Z'),
  ('course_2', 'Python Programming Mastery', 'Master Python programming from basics to advanced concepts. Includes data structures, OOP, and real-world projects.', 'Alex Rivera', 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=400', 'Programming', 'Beginner', 72, 10, 7, 360, 4.9, 5678, false, ARRAY[]::text[], '2025-02-01T00:00:00.000Z'),
  ('course_3', 'Data Structures & Algorithms', 'Comprehensive course on data structures and algorithms for technical interviews and problem-solving.', 'Prof. James Wilson', 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400', 'Computer Science', 'Advanced', 20, 15, 3, 600, 4.7, 1890, false, ARRAY['Basic Programming', 'Python or Java'], '2025-03-01T00:00:00.000Z'),
  ('course_4', 'Natural Language Processing', 'Learn NLP techniques including text processing, sentiment analysis, and transformer models.', 'Dr. Emily Park', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400', 'AI & Data Science', 'Advanced', 0, 10, 0, 420, 4.6, 1234, false, ARRAY['Python', 'Machine Learning Basics'], '2025-04-01T00:00:00.000Z'),
  ('course_5', 'Mobile App Development with Flutter', 'Build beautiful cross-platform mobile apps using Flutter and Dart.', 'Maria Garcia', 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400', 'Mobile Development', 'Intermediate', 15, 12, 2, 480, 4.9, 3456, true, ARRAY['Basic Programming'], '2025-02-15T00:00:00.000Z')
ON CONFLICT (id) DO NOTHING;

-- Lessons for course_1
INSERT INTO lessons (id, course_id, title, content, video_url, duration_minutes, is_completed, is_bookmarked, key_points, summary)
VALUES
  ('lesson_1_1', 'course_1', 'Introduction to Machine Learning', 'Machine learning is a subset of artificial intelligence that enables systems to learn and improve from experience without being explicitly programmed.', NULL, 35, true, false, ARRAY['ML enables computers to learn from data', 'Three main types: supervised, unsupervised, reinforcement', 'Features and labels are fundamental concepts'], 'Machine learning is a transformative technology that allows computers to learn from data without explicit programming.'),
  ('lesson_1_2', 'course_1', 'Data Preprocessing & Feature Engineering', 'Data preprocessing is a crucial step in the machine learning pipeline. Raw data is often messy and needs to be cleaned.', NULL, 40, true, true, ARRAY['Data quality directly impacts model performance', 'Feature engineering can significantly improve results', 'Standardization vs Normalization'], 'This lesson covered the importance of data preprocessing and feature engineering.'),
  ('lesson_1_3', 'course_1', 'Linear Regression & Gradient Descent', 'Linear regression is one of the simplest and most widely used algorithms in machine learning.', NULL, 45, false, false, ARRAY['Linear regression predicts continuous values', 'Gradient descent minimizes the cost function', 'Learning rate affects convergence speed'], 'Linear regression fundamentals and gradient descent optimization.'),
  ('lesson_1_4', 'course_1', 'Neural Networks & Deep Learning', 'Neural networks are computing systems inspired by biological neural networks.', NULL, 50, false, false, ARRAY['Neural networks mimic biological neurons', 'Deep learning uses multiple hidden layers', 'Activation functions introduce non-linearity'], 'Introduction to neural network architecture and activation functions.'),
  ('lesson_1_5', 'course_1', 'Model Evaluation & Validation', 'Evaluating model performance is critical to building reliable ML systems.', NULL, 35, false, false, ARRAY['Choose metrics based on problem type', 'Cross-validation prevents overfitting', 'Confusion matrix helps visualize performance'], 'Comprehensive overview of model evaluation metrics.'),

  -- Lessons for course_2
  ('lesson_2_1', 'course_2', 'Getting Started with Python', 'Python is a high-level, interpreted programming language known for its simplicity and readability.', NULL, 30, true, false, ARRAY['Python emphasizes readability', 'Dynamic typing', 'Interpreted language'], 'Introduction to Python programming language setup and basic syntax.'),
  ('lesson_2_2', 'course_2', 'Control Flow & Functions', 'Learn about conditional statements, loops, and functions in Python.', NULL, 35, true, true, ARRAY['Indentation defines code blocks', 'Functions promote code reuse', 'Lambda for anonymous functions'], 'Understanding control flow mechanisms and function definitions.'),
  ('lesson_2_3', 'course_2', 'Data Structures', 'Python provides built-in data structures that are powerful and easy to use.', NULL, 40, false, false, ARRAY['Lists are mutable, tuples are immutable', 'Dictionaries store key-value pairs', 'Sets store unique elements'], 'Comprehensive guide to Python built-in data structures.'),

  -- Lessons for course_3
  ('lesson_3_1', 'course_3', 'Arrays & Strings', 'Arrays and strings form the foundation of data structures.', NULL, 45, true, false, ARRAY['Arrays provide O(1) access', 'Two-pointer for sorted arrays', 'Sliding window for subarray problems'], 'Fundamental array and string manipulation techniques.'),
  ('lesson_3_2', 'course_3', 'Linked Lists', 'Linked lists are linear data structures where elements are stored in nodes.', NULL, 40, true, false, ARRAY['Dynamic size', 'Sequential access', 'Efficient insertions/deletions'], 'Understanding linked list data structure and its variants.'),
  ('lesson_3_3', 'course_3', 'Trees & Graphs', 'Trees and graphs are hierarchical data structures essential for many algorithms.', NULL, 50, false, false, ARRAY['Trees are acyclic graphs', 'BST enables O(log n) search', 'BFS/DFS for graph exploration'], 'Introduction to tree and graph data structures.'),

  -- Lessons for course_4
  ('lesson_4_1', 'course_4', 'Text Processing & Regex', 'Text preprocessing is essential for NLP tasks.', NULL, 35, false, false, ARRAY['Tokenization splits text into units', 'Lemmatization is more accurate than stemming', 'Regex enables pattern matching'], 'Fundamentals of text preprocessing for NLP applications.'),

  -- Lessons for course_5
  ('lesson_5_1', 'course_5', 'Introduction to Flutter', 'Flutter is Google UI toolkit for building natively compiled applications.', NULL, 30, true, false, ARRAY['Single codebase for multiple platforms', 'Everything is a widget', 'Hot reload for fast development'], 'Introduction to Flutter framework and its core concepts.'),
  ('lesson_5_2', 'course_5', 'Widgets & Layouts', 'Master Flutter layout system and common widgets.', NULL, 40, true, false, ARRAY['Compose widgets for complex UIs', 'Flexible layouts with Row/Column', 'ListView for scrollable content'], 'Understanding Flutter widget composition and layout system.'),
  ('lesson_5_3', 'course_5', 'State Management', 'Learn different state management approaches in Flutter.', NULL, 45, false, false, ARRAY['State management is crucial for complex apps', 'Provider is recommended by Google', 'Choose based on app complexity'], 'Overview of state management solutions in Flutter.')
ON CONFLICT (id) DO NOTHING;

-- Assessments
INSERT INTO assessments (id, title, course_id, course_name, duration_minutes, total_marks, difficulty, scheduled_date)
VALUES
  ('assessment_1', 'Machine Learning Quiz - Week 1', 'course_1', 'Machine Learning Fundamentals', 15, 100, 'Medium', '2025-05-20T00:00:00.000Z'),
  ('assessment_2', 'Python Programming Test', 'course_2', 'Python Programming Mastery', 20, 100, 'Easy', '2025-05-22T00:00:00.000Z'),
  ('assessment_3', 'DSA Problem Solving Challenge', 'course_3', 'Data Structures & Algorithms', 30, 100, 'Hard', '2025-05-25T00:00:00.000Z')
ON CONFLICT (id) DO NOTHING;

-- Questions for assessment_1
INSERT INTO questions (id, assessment_id, question, options, correct_answer, explanation, category, difficulty)
VALUES
  ('q1', 'assessment_1', 'What is the primary goal of supervised learning?',
   ARRAY['To find patterns in unlabeled data', 'To learn a mapping from inputs to outputs using labeled data', 'To maximize reward through trial and error', 'To reduce dimensionality of data'],
   1, 'Supervised learning uses labeled training data to learn a function that maps inputs to outputs.', 'ML Basics', 'Easy'),
  ('q2', 'assessment_1', 'Which of the following is NOT a type of machine learning?',
   ARRAY['Supervised Learning', 'Unsupervised Learning', 'Reinforcement Learning', 'Transactional Learning'],
   3, 'Transactional Learning is not a recognized category of machine learning.', 'ML Basics', 'Easy'),
  ('q3', 'assessment_1', 'What is the purpose of gradient descent in machine learning?',
   ARRAY['To increase the learning rate', 'To minimize the cost function by updating model parameters', 'To add more data to the training set', 'To visualize data in lower dimensions'],
   1, 'Gradient descent iteratively adjusts model parameters to minimize the cost function.', 'Optimization', 'Medium'),
  ('q4', 'assessment_1', 'What does the ReLU activation function do?',
   ARRAY['Outputs values between 0 and 1', 'Outputs the input directly if positive, otherwise outputs zero', 'Outputs the tanh of the input', 'Outputs a probability distribution'],
   1, 'ReLU outputs the input value if it is positive, and zero otherwise.', 'Neural Networks', 'Medium'),
  ('q5', 'assessment_1', 'What is the difference between precision and recall?',
   ARRAY['They are the same thing', 'Precision measures false positives, recall measures false negatives', 'Precision is for classification, recall is for regression', 'Precision measures accuracy, recall measures speed'],
   1, 'Precision minimizes false positives, recall minimizes false negatives.', 'Model Evaluation', 'Hard'),

  -- Questions for assessment_2
  ('q6', 'assessment_2', 'What is the correct way to create a list in Python?',
   ARRAY['list = {1, 2, 3}', 'list = [1, 2, 3]', 'list = (1, 2, 3)', 'list = <1, 2, 3>'],
   1, 'Lists are created using square brackets [].', 'Python Basics', 'Easy'),
  ('q7', 'assessment_2', 'Which of the following is a mutable data type in Python?',
   ARRAY['Tuple', 'String', 'List', 'Integer'],
   2, 'Lists are mutable; tuples, strings, and integers are immutable.', 'Data Structures', 'Easy'),
  ('q8', 'assessment_2', 'What is the output of print(2 ** 3)?',
   ARRAY['6', '8', '9', '5'],
   1, 'The ** operator performs exponentiation. 2 ** 3 = 8.', 'Python Basics', 'Easy'),

  -- Questions for assessment_3
  ('q9', 'assessment_3', 'What is the time complexity of binary search?',
   ARRAY['O(n)', 'O(log n)', 'O(n^2)', 'O(1)'],
   1, 'Binary search has O(log n) time complexity.', 'Algorithms', 'Medium'),
  ('q10', 'assessment_3', 'Which data structure uses FIFO (First In, First Out) principle?',
   ARRAY['Stack', 'Queue', 'Tree', 'Graph'],
   1, 'A Queue follows the FIFO principle.', 'Data Structures', 'Easy'),
  ('q11', 'assessment_3', 'What is a balanced binary tree?',
   ARRAY['A tree where all nodes have two children', 'A tree where the height difference between left and right subtrees is at most 1 for all nodes', 'A tree with equal number of nodes on each side', 'A tree that can only have leaf nodes'],
   1, 'A balanced binary tree maintains a height difference of at most 1.', 'Trees', 'Hard'),
  ('q12', 'assessment_3', 'Which algorithm is used to find the shortest path in a weighted graph?',
   ARRAY['BFS', 'DFS', 'Dijkstra Algorithm', 'Binary Search'],
   2, 'Dijkstra algorithm finds shortest paths in weighted graphs.', 'Graphs', 'Hard')
ON CONFLICT (id) DO NOTHING;

-- Assignments
INSERT INTO assignments (id, title, description, course_id, course_name, type, due_date, total_marks, obtained_marks, status, file_url, feedback, ai_score, ai_recommendations, created_at)
VALUES
  ('assign_1', 'ML Model Implementation', 'Implement a linear regression model from scratch using Python.', 'course_1', 'Machine Learning Fundamentals', 'code', '2025-05-25T23:59:00.000Z', 100, 0, 'pending', NULL, NULL, NULL, NULL, '2025-05-10T00:00:00.000Z'),
  ('assign_2', 'Python Data Analysis Project', 'Analyze the provided sales dataset using Python pandas and matplotlib.', 'course_2', 'Python Programming Mastery', 'pdf', '2025-05-20T23:59:00.000Z', 100, 0, 'pending', NULL, NULL, NULL, NULL, '2025-05-05T00:00:00.000Z'),
  ('assign_3', 'Binary Search Tree Implementation', 'Implement a complete Binary Search Tree with insert, delete, search, and traversal operations.', 'course_3', 'Data Structures & Algorithms', 'code', '2025-05-28T23:59:00.000Z', 100, 0, 'pending', NULL, NULL, NULL, NULL, '2025-05-12T00:00:00.000Z'),
  ('assign_4', 'Sentiment Analysis Report', 'Build a sentiment analysis model using the provided Twitter dataset.', 'course_4', 'Natural Language Processing', 'pdf', '2025-06-01T23:59:00.000Z', 100, 85, 'graded', 'https://example.com/submissions/sentiment_report.pdf', 'Excellent work! Consider trying transformer-based models.', 85, ARRAY['Try using BERT or RoBERTa', 'Include confusion matrix', 'Consider cross-validation'], '2025-05-01T00:00:00.000Z'),
  ('assign_5', 'Flutter UI Challenge', 'Create a beautiful login screen with animations and form validation using Flutter.', 'course_5', 'Mobile App Development with Flutter', 'code', '2025-05-30T23:59:00.000Z', 100, 92, 'graded', 'https://example.com/submissions/flutter_ui.zip', 'Great UI implementation! Animations are smooth.', 92, ARRAY['Add error handling', 'Implement responsive design', 'Use const constructors'], '2025-05-08T00:00:00.000Z')
ON CONFLICT (id) DO NOTHING;

-- Activities
INSERT INTO activities (id, user_id, type, title, description, course_name, timestamp)
VALUES
  ('act_1', 'user_1', 'lesson', 'Completed: Introduction to ML', 'You finished the first lesson of Machine Learning Fundamentals', 'Machine Learning Fundamentals', '2025-05-19T10:00:00.000Z'),
  ('act_2', 'user_1', 'quiz', 'Quiz Score: 85%', 'Python Programming Test - Week 2', 'Python Programming Mastery', '2025-05-18T14:30:00.000Z'),
  ('act_3', 'user_1', 'achievement', '7-Day Streak!', 'You have been learning for 7 consecutive days', NULL, '2025-05-19T00:00:00.000Z'),
  ('act_4', 'user_1', 'course', 'Started: Data Structures & Algorithms', 'You enrolled in a new course', 'Data Structures & Algorithms', '2025-05-17T09:00:00.000Z'),
  ('act_5', 'user_1', 'assignment', 'Assignment Graded: Flutter UI', 'Your assignment scored 92/100', 'Mobile App Development with Flutter', '2025-05-16T16:00:00.000Z')
ON CONFLICT (id) DO NOTHING;

-- Analytics (JSONB for nested sub-data)
INSERT INTO analytics (id, user_id, weekly_progress, skills, heatmap, performance, recommendations, completion_stats)
VALUES (
  'analytics_1', 'user_1',
  '[{"day":"Mon","hours":2,"lessonsCompleted":3,"quizzesTaken":1},{"day":"Tue","hours":1,"lessonsCompleted":2,"quizzesTaken":0},{"day":"Wed","hours":3,"lessonsCompleted":4,"quizzesTaken":2},{"day":"Thu","hours":1.5,"lessonsCompleted":2,"quizzesTaken":1},{"day":"Fri","hours":2.5,"lessonsCompleted":3,"quizzesTaken":1},{"day":"Sat","hours":0.5,"lessonsCompleted":1,"quizzesTaken":0},{"day":"Sun","hours":1,"lessonsCompleted":1,"quizzesTaken":0}]'::jsonb,
  '[{"name":"Python","proficiency":85,"category":"Programming"},{"name":"Machine Learning","proficiency":62,"category":"AI"},{"name":"Data Structures","proficiency":45,"category":"CS"},{"name":"Algorithms","proficiency":50,"category":"CS"},{"name":"Flutter","proficiency":30,"category":"Mobile"},{"name":"NLP","proficiency":15,"category":"AI"},{"name":"Statistics","proficiency":70,"category":"Math"}]'::jsonb,
  '[{"date":"2025-05-13","intensity":3,"label":"3 hours"},{"date":"2025-05-14","intensity":2,"label":"2 hours"},{"date":"2025-05-15","intensity":4,"label":"4 hours"},{"date":"2025-05-16","intensity":1,"label":"1 hour"},{"date":"2025-05-17","intensity":3,"label":"3 hours"},{"date":"2025-05-18","intensity":0,"label":"0 hours"},{"date":"2025-05-19","intensity":2,"label":"2 hours"}]'::jsonb,
  '[{"subject":"Machine Learning","scores":[65,72,78,85,82,88],"labels":["Quiz 1","Quiz 2","Quiz 3","Midterm","Quiz 4","Final"]},{"subject":"Python","scores":[80,85,90,88,92,95],"labels":["Week 1","Week 2","Week 3","Week 4","Week 5","Week 6"]},{"subject":"DSA","scores":[45,55,60,58,65,70],"labels":["Test 1","Test 2","Test 3","Test 4","Test 5","Test 6"]}]'::jsonb,
  '[{"id":"rec_1","title":"Review Tree Data Structures","description":"Your performance in tree-related questions needs improvement.","type":"course","priority":"high"},{"id":"rec_2","title":"Complete NLP Module","description":"Start the Natural Language Processing course to expand your skills.","type":"course","priority":"medium"},{"id":"rec_3","title":"Practice Dynamic Programming","description":"DP is a common interview topic.","type":"practice","priority":"high"},{"id":"rec_4","title":"Review Statistics Fundamentals","description":"Strengthen your statistics foundation for better ML model understanding.","type":"resource","priority":"low"}]'::jsonb,
  '{"totalCourses":5,"completedCourses":1,"totalLessons":59,"completedLessons":17,"totalQuizzes":12,"completedQuizzes":8,"totalAssignments":6,"submittedAssignments":4,"totalHoursLearned":42}'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- Admin data (JSONB)
INSERT INTO admin_data (id, students, batches, faculty, reports)
VALUES (
  'admin_1',
  '[{"id":"s1","name":"Emma Wilson","email":"emma@uni.edu","avatar":"https://i.pravatar.cc/150?u=emma","courseCount":4,"completionRate":78,"averageScore":82,"lastActive":"2025-05-19T09:00:00.000Z","status":"active"},{"id":"s2","name":"Liam Brown","email":"liam@uni.edu","avatar":"https://i.pravatar.cc/150?u=liam","courseCount":3,"completionRate":65,"averageScore":74,"lastActive":"2025-05-18T15:30:00.000Z","status":"active"},{"id":"s3","name":"Sophia Davis","email":"sophia@uni.edu","avatar":"https://i.pravatar.cc/150?u=sophia","courseCount":5,"completionRate":92,"averageScore":95,"lastActive":"2025-05-19T11:00:00.000Z","status":"active"},{"id":"s4","name":"Noah Martinez","email":"noah@uni.edu","avatar":"https://i.pravatar.cc/150?u=noah","courseCount":2,"completionRate":45,"averageScore":68,"lastActive":"2025-05-15T10:00:00.000Z","status":"inactive"},{"id":"s5","name":"Olivia Taylor","email":"olivia@uni.edu","avatar":"https://i.pravatar.cc/150?u=olivia","courseCount":4,"completionRate":88,"averageScore":90,"lastActive":"2025-05-19T08:00:00.000Z","status":"active"}]'::jsonb,
  '[{"id":"b1","name":"CS 2025 Batch A","course":"Machine Learning Fundamentals","studentCount":45,"avgProgress":62,"avgScore":75,"startDate":"2025-01-15","endDate":"2025-06-30"},{"id":"b2","name":"CS 2025 Batch B","course":"Python Programming Mastery","studentCount":52,"avgProgress":78,"avgScore":84,"startDate":"2025-02-01","endDate":"2025-07-31"},{"id":"b3","name":"DS 2025 Batch","course":"Data Structures & Algorithms","studentCount":38,"avgProgress":35,"avgScore":68,"startDate":"2025-03-01","endDate":"2025-08-31"}]'::jsonb,
  '[{"id":"f1","name":"Dr. Sarah Chen","email":"sarah.chen@uni.edu","avatar":"https://i.pravatar.cc/150?u=sarahchen","department":"Computer Science","courses":3,"students":120,"rating":4.8},{"id":"f2","name":"Alex Rivera","email":"alex.rivera@uni.edu","avatar":"https://i.pravatar.cc/150?u=alexrivera","department":"Computer Science","courses":2,"students":85,"rating":4.9}]'::jsonb,
  '{"totalStudents":135,"activeStudents":98,"totalCourses":5,"averageCompletionRate":72,"averageScore":81,"totalHoursLearned":2850}'::jsonb
)
ON CONFLICT (id) DO NOTHING;
