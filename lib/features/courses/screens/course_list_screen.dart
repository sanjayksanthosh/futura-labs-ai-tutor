import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/course_provider.dart';
import '../../../widgets/course_card.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/skeleton_loader.dart';
import '../../../widgets/empty_state.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showBookmarked = false;

  final List<String> _categories = [
    'All',
    'AI & Data Science',
    'Programming',
    'Computer Science',
    'Mobile Development',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.surfaceDark, AppColors.backgroundDark]
                : [const Color(0xFFF0F0FF), const Color(0xFFF8F9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Explore Courses',
                subtitle: 'Learn from expert instructors',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark
                        ? AppColors.cardDark
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white12
                            : AppColors.textLight.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ..._categories.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (_) {
                              setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.primary,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedCategory == cat
                                  ? Colors.white
                                  : null,
                              fontSize: 12,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: FilterChip(
                        label: const Text('Bookmarked'),
                        selected: _showBookmarked,
                        onSelected: (_) {
                          setState(() => _showBookmarked = !_showBookmarked);
                        },
                        selectedColor: AppColors.accent,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: _showBookmarked ? Colors.white : null,
                          fontSize: 12,
                        ),
                        avatar: Icon(
                          Icons.bookmark,
                          size: 14,
                          color: _showBookmarked ? Colors.white : AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<CourseProvider>(
                  builder: (_, cp, __) {
                    if (cp.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CardSkeleton(),
                            CardSkeleton(),
                          ],
                        ),
                      );
                    }

                    var filtered = cp.courses;
                    if (_showBookmarked) {
                      filtered = filtered.where((c) => c.isBookmarked).toList();
                    }
                    if (_selectedCategory != 'All') {
                      filtered = filtered
                          .where((c) => c.category == _selectedCategory)
                          .toList();
                    }
                    if (_searchController.text.isNotEmpty) {
                      final query = _searchController.text.toLowerCase();
                      filtered = filtered
                          .where((c) =>
                              c.title.toLowerCase().contains(query) ||
                              c.instructor.toLowerCase().contains(query))
                          .toList();
                    }

                    if (filtered.isEmpty) {
                      return const EmptyState(
                        icon: Icons.search_off,
                        title: 'No courses found',
                        subtitle: 'Try adjusting your search or filters',
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final course = filtered[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CourseCard(
                            title: course.title,
                            instructor: course.instructor,
                            thumbnail: course.thumbnail,
                            category: course.category,
                            difficulty: course.difficulty,
                            progress: course.progress,
                            rating: course.rating,
                            totalLessons: course.totalLessons,
                            durationMinutes: course.durationMinutes,
                            isBookmarked: course.isBookmarked,
                            onTap: () => context.push(
                              '/course-detail',
                              extra: course.id,
                            ),
                            onBookmark: () => cp.toggleBookmark(course.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
