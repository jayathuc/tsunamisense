import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/lesson_provider.dart';
import '../../../data/models/lesson.dart';

/// Learn screen - Education module with lessons
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        actions: [
          Consumer<LessonProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${provider.completedCount}/${provider.totalCount} completed',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<LessonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.lessons.isEmpty) {
            return const Center(
              child: Text('No lessons available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Overview
                _buildProgressCard(context, provider),
                const SizedBox(height: 24),

                // Lessons List
                Text(
                  'Lessons',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...provider.lessons.map((lesson) => _LessonCard(
                  lesson: lesson,
                  onTap: () => _openLesson(context, lesson),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, LessonProvider provider) {
    final progress = provider.completionPercentage;

    return Card(
      color: AppTheme.primaryBlue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Learning Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toInt()}% Complete',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
              ),
            ),
            if (progress < 1.0) ...[
              const SizedBox(height: 12),
              Text(
                progress == 0
                    ? 'Start your first lesson to learn how to stay safe!'
                    : 'Keep going! You\'re doing great!',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.alertGreen),
                  const SizedBox(width: 8),
                  Text(
                    'All lessons completed! You\'re well prepared.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.alertGreen,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(lesson: lesson),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson Number
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: lesson.isCompleted
                      ? AppTheme.alertGreen
                      : AppTheme.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: lesson.isCompleted
                      ? const Icon(Icons.check, color: Colors.white)
                      : Text(
                          '${lesson.order}',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: lesson.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.estimatedMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (lesson.quiz != null) ...[
                          const SizedBox(width: 12),
                          const Icon(Icons.quiz, size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Quiz',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lesson Detail Screen
class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _showQuiz = false;
  int _currentQuizIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson ${widget.lesson.order}'),
      ),
      body: _showQuiz ? _buildQuiz() : _buildContent(),
      bottomNavigationBar: _showQuiz ? null : _buildBottomBar(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lesson.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${widget.lesson.estimatedMinutes} min read',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Divider(height: 32),
          // Render markdown-like content
          _buildMarkdownContent(widget.lesson.content),
        ],
      ),
    );
  }

  Widget _buildMarkdownContent(String content) {
    final theme = Theme.of(context);
    final lines = content.split('\n');
    final widgets = <Widget>[];

    Widget richLine(String text, TextStyle? style, EdgeInsets padding) => Padding(
          padding: padding,
          child: Text.rich(TextSpan(children: _inlineSpans(text, style))),
        );

    for (final line in lines) {
      if (line.startsWith('### ')) {
        widgets.add(richLine(line.substring(4), theme.textTheme.titleMedium,
            const EdgeInsets.only(top: 8, bottom: 4)));
      } else if (line.startsWith('## ')) {
        widgets.add(richLine(line.substring(3), theme.textTheme.titleLarge,
            const EdgeInsets.only(top: 12, bottom: 8)));
      } else if (line.startsWith('# ')) {
        widgets.add(richLine(line.substring(2), theme.textTheme.headlineSmall,
            const EdgeInsets.only(top: 16, bottom: 8)));
      } else if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          line.startsWith('• ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: Icon(Icons.circle, size: 6, color: AppTheme.primaryBlue),
              ),
              Expanded(
                child: Text.rich(TextSpan(
                    children: _inlineSpans(
                        line.substring(2), theme.textTheme.bodyMedium))),
              ),
            ],
          ),
        ));
      } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
        final match = RegExp(r'^(\d+)\. (.*)').firstMatch(line)!;
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('${match.group(1)}.',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue)),
              ),
              Expanded(
                child: Text.rich(TextSpan(
                    children: _inlineSpans(
                        match.group(2)!, theme.textTheme.bodyMedium))),
              ),
            ],
          ),
        ));
      } else if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.add(richLine(line, theme.textTheme.bodyMedium,
            const EdgeInsets.only(bottom: 6)));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// Parse inline markdown (**bold**, *italic*, `code`) into styled spans.
  List<InlineSpan> _inlineSpans(String text, TextStyle? base) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|__(.+?)__|\*(.+?)\*|_(.+?)_|`(.+?)`');
    var last = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: base));
      }
      final bold = m.group(1) ?? m.group(2);
      final italic = m.group(3) ?? m.group(4);
      final code = m.group(5);
      final b = base ?? const TextStyle();
      if (bold != null) {
        spans.add(TextSpan(
            text: bold, style: b.copyWith(fontWeight: FontWeight.bold)));
      } else if (italic != null) {
        spans.add(TextSpan(
            text: italic, style: b.copyWith(fontStyle: FontStyle.italic)));
      } else if (code != null) {
        spans.add(TextSpan(text: code, style: b.copyWith(fontFamily: 'monospace')));
      }
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    if (spans.isEmpty) spans.add(TextSpan(text: text, style: base));
    return spans;
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (widget.lesson.quiz != null && !widget.lesson.isCompleted)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showQuiz = true;
                    });
                  },
                  child: const Text('Take Quiz'),
                ),
              )
            else
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _completeLesson(),
                  child: Text(widget.lesson.isCompleted
                      ? 'Completed ✓'
                      : 'Mark as Complete'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final quiz = widget.lesson.quiz!;
    if (_currentQuizIndex >= quiz.length) {
      return _buildQuizResults();
    }

    final question = quiz[_currentQuizIndex];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          LinearProgressIndicator(
            value: (_currentQuizIndex + 1) / quiz.length,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${_currentQuizIndex + 1} of ${quiz.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Question
          Text(
            question.question,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == index;
            final isCorrect = index == question.correctIndex;
            final showResult = _selectedAnswer != null;

            Color? backgroundColor;
            if (showResult) {
              if (isCorrect) {
                backgroundColor = AppTheme.alertGreen.withOpacity(0.2);
              } else if (isSelected && !isCorrect) {
                backgroundColor = AppTheme.alertRed.withOpacity(0.2);
              }
            } else if (isSelected) {
              backgroundColor = AppTheme.primaryBlue.withOpacity(0.2);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _selectedAnswer == null
                    ? () {
                        setState(() {
                          _selectedAnswer = index;
                          if (isCorrect) _correctAnswers++;
                        });
                      }
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(option)),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle, color: AppTheme.alertGreen),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: AppTheme.alertRed),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Explanation
          if (_selectedAnswer != null && question.explanation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(question.explanation!),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Next button
          if (_selectedAnswer != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentQuizIndex++;
                    _selectedAnswer = null;
                  });
                },
                child: Text(_currentQuizIndex < quiz.length - 1 ? 'Next' : 'See Results'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizResults() {
    final total = widget.lesson.quiz!.length;
    final percentage = (_correctAnswers / total * 100).toInt();
    final passed = percentage >= 70;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.refresh,
              size: 80,
              color: passed ? AppTheme.alertGreen : AppTheme.alertOrange,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? 'Great Job!' : 'Keep Learning',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'You got $_correctAnswers out of $total correct ($percentage%)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (passed)
              ElevatedButton(
                onPressed: () => _completeLesson(),
                child: const Text('Complete Lesson'),
              )
            else
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showQuiz = false;
                    _currentQuizIndex = 0;
                    _correctAnswers = 0;
                    _selectedAnswer = null;
                  });
                },
                child: const Text('Review Lesson'),
              ),
          ],
        ),
      ),
    );
  }

  void _completeLesson() {
    context.read<LessonProvider>().markLessonCompleted(widget.lesson.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lesson "${widget.lesson.title}" completed!'),
        backgroundColor: AppTheme.alertGreen,
      ),
    );
  }
}
