-- Create users table
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  avatar TEXT,
  role TEXT DEFAULT 'student',
  institution TEXT,
  streak INTEGER DEFAULT 0,
  total_courses INTEGER DEFAULT 0,
  completed_lessons INTEGER DEFAULT 0,
  ai_score DOUBLE PRECISION DEFAULT 0,
  weekly_progress DOUBLE PRECISION DEFAULT 0,
  last_active TIMESTAMPTZ
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create courses table
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  instructor TEXT,
  thumbnail TEXT,
  category TEXT,
  difficulty TEXT DEFAULT 'Beginner',
  progress DOUBLE PRECISION DEFAULT 0,
  total_lessons INTEGER DEFAULT 0,
  completed_lessons INTEGER DEFAULT 0,
  duration_minutes INTEGER DEFAULT 0,
  rating DOUBLE PRECISION DEFAULT 0,
  student_count INTEGER DEFAULT 0,
  is_bookmarked BOOLEAN DEFAULT false,
  prerequisites TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE courses ENABLE ROW LEVEL SECURITY;

-- Create lessons table
CREATE TABLE lessons (
  id TEXT PRIMARY KEY,
  course_id TEXT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT DEFAULT '',
  video_url TEXT,
  duration_minutes INTEGER DEFAULT 0,
  is_completed BOOLEAN DEFAULT false,
  is_bookmarked BOOLEAN DEFAULT false,
  key_points TEXT[] DEFAULT '{}',
  summary TEXT
);

ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;

-- Create assessments table
CREATE TABLE assessments (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  course_id TEXT REFERENCES courses(id),
  course_name TEXT,
  duration_minutes INTEGER DEFAULT 30,
  total_marks INTEGER DEFAULT 100,
  difficulty TEXT DEFAULT 'Medium',
  scheduled_date TIMESTAMPTZ
);

ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;

-- Create questions table
CREATE TABLE questions (
  id TEXT PRIMARY KEY,
  assessment_id TEXT NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  options TEXT[] NOT NULL,
  correct_answer INTEGER NOT NULL,
  explanation TEXT,
  category TEXT DEFAULT 'General',
  difficulty TEXT DEFAULT 'Medium'
);

ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Create assignments table
CREATE TABLE assignments (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  course_id TEXT REFERENCES courses(id),
  course_name TEXT,
  type TEXT DEFAULT 'PDF',
  due_date TIMESTAMPTZ,
  total_marks INTEGER DEFAULT 100,
  obtained_marks INTEGER DEFAULT 0,
  status TEXT DEFAULT 'pending',
  file_url TEXT,
  feedback TEXT,
  ai_score DOUBLE PRECISION,
  ai_recommendations TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

-- Create activities table
CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id),
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  course_name TEXT,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  icon_url TEXT
);

ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Create analytics table (JSONB for nested sub-data)
CREATE TABLE analytics (
  id TEXT PRIMARY KEY,
  user_id TEXT UNIQUE NOT NULL REFERENCES users(id),
  weekly_progress JSONB DEFAULT '[]'::jsonb,
  skills JSONB DEFAULT '[]'::jsonb,
  heatmap JSONB DEFAULT '[]'::jsonb,
  performance JSONB DEFAULT '[]'::jsonb,
  recommendations JSONB DEFAULT '[]'::jsonb,
  completion_stats JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE analytics ENABLE ROW LEVEL SECURITY;

-- Create admin_data table (JSONB for complex admin data)
CREATE TABLE admin_data (
  id TEXT PRIMARY KEY DEFAULT 'admin_1',
  students JSONB DEFAULT '[]'::jsonb,
  batches JSONB DEFAULT '[]'::jsonb,
  faculty JSONB DEFAULT '[]'::jsonb,
  reports JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE admin_data ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for public read access (adjust as needed)
CREATE POLICY "Allow public read users" ON users FOR SELECT USING (true);
CREATE POLICY "Allow public read courses" ON courses FOR SELECT USING (true);
CREATE POLICY "Allow public read lessons" ON lessons FOR SELECT USING (true);
CREATE POLICY "Allow public read assessments" ON assessments FOR SELECT USING (true);
CREATE POLICY "Allow public read questions" ON questions FOR SELECT USING (true);
CREATE POLICY "Allow public read assignments" ON assignments FOR SELECT USING (true);
CREATE POLICY "Allow public read activities" ON activities FOR SELECT USING (true);
CREATE POLICY "Allow public read analytics" ON analytics FOR SELECT USING (true);
CREATE POLICY "Allow public read admin_data" ON admin_data FOR SELECT USING (true);
