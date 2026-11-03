# FuturaLabs Ai Tutor

An AI-powered educational mobile app built with Flutter. Features personalized learning paths, AI-generated courses, smart assessments, student analytics, and an institution dashboard.

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **GoRouter** - Navigation
- **fl_chart** - Charts & visualizations
- **flutter_animate** - Animations
- **shimmer** - Loading skeletons
- **flutter_markdown** - Markdown content
- **google_fonts** - Typography
- **dio** - HTTP client (prepared for future APIs)
- **shared_preferences** - Local storage
- **file_picker / image_picker** - File uploads

## Features

### 1. Authentication
- Splash screen with animations
- Onboarding flow (3 screens)
- Login with form validation & social login placeholders
- Signup with validation
- Forgot password flow
- Token/session ready using SharedPreferences

### 2. Student Dashboard
- Greeting header with streak badge
- AI Assistant recommendation card
- Continue Learning horizontal scroll
- Recommended Courses section
- Progress cards (Total Courses, Completed, AI Score, Hours)
- Weekly progress bar chart
- Recent activity feed
- Dashboard cards with gradient design
- Skeleton loading states

### 3. AI Learning Module
- Course listing with search & category filters
- Bookmarked courses filter
- Course detail with instructor info & prerequisites
- Lesson player with markdown content
- Video player placeholder (ready for YouTube/Vimeo)
- Key points & AI summary cards
- AI Tutor Q&A panel
- Bookmark & lesson completion

### 4. Smart Assessments
- Assessment listing with difficulty badges
- Quiz screen with:
  - Page-based question navigation
  - Timer with visual warning
  - Answer selection with highlighting
  - Mark for review flag
  - Submit confirmation dialog
- Result screen with:
  - Animated circular score indicator
  - Grade display
  - Stats (correct/incorrect/unanswered)
  - Review answers with explanations

### 5. Assignment Upload
- Assignment list with status tracking
- File picker (PDF, Images, Notes, Code)
- Upload progress indicator
- AI evaluation result page with:
  - Score with animated indicator
  - Feedback text
  - Strengths, improvements, suggestions

### 6. Student Analytics
- Completion stats with circular progress
- Weekly hours bar chart
- Skill proficiency bars
- Performance trend line chart (multi-subject)
- AI recommendations with priority levels

### 7. Institution Admin Panel
- Tab-based navigation (Overview, Students, Batches, Faculty)
- Stats cards (Total Students, Active, Courses, Hours)
- Batch progress bar chart
- Student list with status badges
- Batch cards with progress & scores
- Faculty cards with ratings

### 8. Settings
- Profile card with avatar
- Dark/Light theme toggle
- Notification toggle
- Download management
- Profile editing (UI ready)
- Logout with confirmation

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App colors & constants
│   ├── theme/           # Light/dark theme config
│   ├── utils/           # Responsive, validators, string utils
│   └── app_router.dart  # GoRouter configuration
├── services/
│   └── mock_service.dart # Mock data service (swap for real API)
├── models/              # Data models
├── providers/           # State management (ChangeNotifier)
├── features/
│   ├── auth/            # Login, signup, onboarding, splash
│   ├── dashboard/       # Student dashboard
│   ├── courses/         # Course listing, detail, lesson player
│   ├── assessments/     # Quiz, results, review
│   ├── assignments/     # Upload, evaluation
│   ├── analytics/       # Charts, stats, recommendations
│   ├── admin/           # Institution management
│   └── settings/        # Profile, theme, preferences
├── widgets/             # Reusable components
└── main.dart            # App entry with MultiProvider
```

## Getting Started

### Prerequisites

- Flutter SDK >=3.10.7
- Dart SDK >=3.10.7

### Installation

```bash
# Clone the repository
git clone https://github.com/sanjayksanthosh/futura-labs-ai-tutor.git

# Navigate to project
cd futura_labs_ai_tutor

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## Backend Integration Guide

### Architecture for API Integration

The app uses a **mock repository pattern**. To connect real APIs:

1. **MockService** (`lib/services/mock_service.dart`) - Currently serves JSON from assets. Replace its methods with `Dio` HTTP calls.

2. **Models** are already JSON-serializable (`fromJson`/`toJson`) - ready for API responses.

3. **Providers** call the service layer. Swap `MockService` with an `ApiService` class:

```dart
class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.futuralabs.com/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<CourseModel>> getCourses() async {
    final response = await _dio.get('/courses');
    return (response.data as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }
}
```

### Recommended API Structure

```
GET    /api/v1/auth/login
POST   /api/v1/auth/signup
POST   /api/v1/auth/forgot-password
GET    /api/v1/auth/profile
PUT    /api/v1/auth/profile

GET    /api/v1/courses
GET    /api/v1/courses/:id
GET    /api/v1/courses/:id/lessons
POST   /api/v1/courses/:id/lessons/:id/complete
POST   /api/v1/courses/:id/bookmark

GET    /api/v1/assessments
GET    /api/v1/assessments/:id
POST   /api/v1/assessments/:id/submit
GET    /api/v1/assessments/results/:id

GET    /api/v1/assignments
POST   /api/v1/assignments/:id/upload
GET    /api/v1/assignments/:id/evaluation

GET    /api/v1/analytics/:userId
GET    /api/v1/analytics/:userId/progress
GET    /api/v1/analytics/:userId/recommendations

GET    /api/v1/admin/dashboard
GET    /api/v1/admin/students
GET    /api/v1/admin/batches
GET    /api/v1/admin/faculty
```

### Firebase Setup (Future)

- `google-services.json` / `GoogleService-Info.plist` go in respective platform folders
- Enable Authentication, Firestore, Cloud Functions
- Provider pattern supports FirebaseAuth integration in `AuthProvider`

## Design Decisions

- **Provider over Riverpod/Bloc** for simplicity and readability
- **Glassmorphism cards** with gradient backgrounds for futuristic AI look
- **Mock data in assets** allows the app to run fully offline
- **Feature-first architecture** makes it easy to locate and modify code
- **Responsive layout** adapts to phones and tablets
- **Skeleton loaders** for perceived performance during data loading

## License

MIT
