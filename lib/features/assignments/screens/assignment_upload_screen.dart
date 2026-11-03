import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assignment_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';

class AssignmentUploadScreen extends StatefulWidget {
  const AssignmentUploadScreen({super.key});

  @override
  State<AssignmentUploadScreen> createState() =>
      _AssignmentUploadScreenState();
}

class _AssignmentUploadScreenState extends State<AssignmentUploadScreen> {
  String? _selectedFileName;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedFileName == null) return;
    setState(() => _isUploading = true);
    final ap = context.read<AssignmentProvider>();
    ap.simulateUpload();
    await Future.delayed(const Duration(seconds: 3));
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id != null) {
      await ap.submitAssignment(id);
    }
    if (mounted) {
      setState(() => _isUploading = false);
      context.replace('/assignment-evaluation', extra: id);
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload Assignment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Submit your work for AI evaluation',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _buildFilePicker(context),
                const SizedBox(height: 24),
                _buildUploadTypes(context),
                const SizedBox(height: 24),
                if (_isUploading)
                  Consumer<AssignmentProvider>(
                    builder: (_, ap, __) => Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: ap.uploadProgress,
                            minHeight: 6,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(ap.uploadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                GradientButton(
                  label: _isUploading
                      ? 'Uploading...'
                      : 'Submit Assignment',
                  isLoading: _isUploading,
                  onPressed:
                      _selectedFileName != null && !_isUploading ? _submit : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: _pickFile,
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFileName ?? 'Tap to select file',
              style: TextStyle(
                fontSize: 14,
                color: _selectedFileName != null
                    ? AppColors.primary
                    : isDark
                        ? Colors.white60
                        : AppColors.textSecondary,
                fontWeight:
                    _selectedFileName != null ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Supports PDF, Images, Code files',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTypes(BuildContext context) {
    final types = [
      {'icon': Icons.picture_as_pdf, 'label': 'PDF'},
      {'icon': Icons.image, 'label': 'Image'},
      {'icon': Icons.note, 'label': 'Notes'},
      {'icon': Icons.code, 'label': 'Code'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: types.map((t) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(t['icon'] as IconData,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 4),
            Text(t['label'] as String,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        );
      }).toList(),
    );
  }
}
