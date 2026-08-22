import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/checklist_provider.dart';
import '../../../data/models/checklist.dart';
import '../../../core/theme/app_theme.dart';

/// Prepare screen - Emergency preparedness checklist
class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key});

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  // The checklist is loaded (and reloaded on language change) from
  // MainNavigationScreen with the active locale, so we do not load it here;
  // doing so would force it back to the default language.

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.prepareTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _showResetDialog(context),
            tooltip: l.prepareResetTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareChecklist(context),
            tooltip: l.prepareShareTooltip,
          ),
        ],
      ),
      body: Consumer<ChecklistProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // Progress header
              SliverToBoxAdapter(
                child: _ProgressHeader(
                  completedItems: provider.completedItemsCount,
                  totalItems: provider.totalItemsCount,
                  percentage: provider.completionPercentage,
                ),
              ),

              // Category list
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = provider.categories[index];
                      return _CategoryCard(
                        category: category,
                        onItemToggled: (itemId) {
                          provider.toggleItem(category.id, itemId);
                        },
                        onItemNoteUpdated: (itemId, note) {
                          provider.updateItemNote(category.id, itemId, note);
                        },
                      );
                    },
                    childCount: provider.categories.length,
                  ),
                ),
              ),

              // Tips section
              const SliverToBoxAdapter(
                child: _TipsSection(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l.prepareAddItem),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.prepareResetTitle),
        content: Text(l.prepareResetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChecklistProvider>().resetChecklist();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.prepareResetDone)),
              );
            },
            child: Text(l.commonReset),
          ),
        ],
      ),
    );
  }

  void _shareChecklist(BuildContext context) {
    final provider = context.read<ChecklistProvider>();
    final text = _generateChecklistText(provider);
    Share.share(text, subject: 'TsunamiSense Emergency Checklist');
  }

  String _generateChecklistText(ChecklistProvider provider) {
    final buffer = StringBuffer();
    buffer.writeln('🌊 TsunamiSense Emergency Checklist');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln(
      'Progress: ${provider.completedItemsCount}/${provider.totalItemsCount} '
      '(${(provider.completionPercentage * 100).toStringAsFixed(0)}%)',
    );
    buffer.writeln();

    for (final category in provider.categories) {
      buffer.writeln('${category.icon} ${category.name}');
      for (final item in category.items) {
        final status = item.isCompleted ? '✅' : '⬜';
        buffer.writeln('  $status ${item.name}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  void _showAddItemDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = context.read<ChecklistProvider>();
    String? selectedCategory;
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.prepareAddCustomTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l.prepareCategory,
                border: const OutlineInputBorder(),
              ),
              items: provider.categories.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l.prepareItemName,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCategory != null && nameController.text.isNotEmpty) {
                provider.addCustomItem(selectedCategory!, nameController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.prepareItemAdded)),
                );
              }
            },
            child: Text(l.commonAdd),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int completedItems;
  final int totalItems;
  final double percentage;

  const _ProgressHeader({
    required this.completedItems,
    required this.totalItems,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isComplete = percentage >= 1.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isComplete
              ? [AppTheme.alertGreen, AppTheme.alertGreen.withValues(alpha: 0.8)]
              : [AppTheme.primaryBlue, AppTheme.primaryBlue.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(percentage * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$completedItems/$totalItems',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isComplete
                          ? l.prepareFullyPrepared
                          : l.preparePreparednessLevel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isComplete
                          ? l.prepareCompleteMsg
                          : l.prepareIncompleteMsg,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final ChecklistCategory category;
  final Function(String) onItemToggled;
  final Function(String, String?) onItemNoteUpdated;

  const _CategoryCard({
    required this.category,
    required this.onItemToggled,
    required this.onItemNoteUpdated,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final completedCount =
        widget.category.items.where((i) => i.isCompleted).length;
    final totalCount = widget.category.items.length;
    final percentage = totalCount > 0 ? completedCount / totalCount : 0.0;
    final isComplete = percentage >= 1.0;
    final color = isComplete ? AppTheme.alertGreen : AppTheme.primaryBlue;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // icon badge (real Material icon, not the raw name string)
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_iconFor(widget.category.icon),
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.category.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isComplete)
                              const Icon(Icons.check_circle,
                                  color: AppTheme.alertGreen, size: 20)
                            else
                              Text('${(percentage * 100).round()}%',
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 6,
                            backgroundColor: color.withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                            AppLocalizations.of(context)
                                .prepareItemsComplete(completedCount, totalCount),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Items
          if (_isExpanded) ...[
            const Divider(height: 1),
            ...widget.category.items.map((item) => _ChecklistItemTile(
                  item: item,
                  onToggle: () => widget.onItemToggled(item.id),
                  onNoteUpdate: (note) =>
                      widget.onItemNoteUpdated(item.id, note),
                )),
          ],
        ],
      ),
    );
  }

  /// Map the stored Material icon name to its IconData (tree-shake friendly).
  IconData _iconFor(String name) {
    switch (name) {
      case 'backpack':
        return Icons.backpack;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'water_drop':
        return Icons.water_drop;
      case 'medical_services':
        return Icons.medical_services;
      case 'pets':
        return Icons.pets;
      case 'phone':
        return Icons.phone_iphone;
      case 'description':
        return Icons.description;
      default:
        return Icons.checklist;
    }
  }
}

class _ChecklistItemTile extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;
  final Function(String?) onNoteUpdate;

  const _ChecklistItemTile({
    required this.item,
    required this.onToggle,
    required this.onNoteUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      onLongPress: () => _showNoteDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Checkbox(
              value: item.isCompleted,
              onChanged: (_) => onToggle(),
              activeColor: AppTheme.alertGreen,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      decoration:
                          item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  if (item.description != null)
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (item.note != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '📝 ${item.note}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (item.isRequired)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.alertRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.of(context).prepareRequired,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.alertRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                item.note != null ? Icons.note : Icons.note_add_outlined,
                size: 20,
                color: item.note != null ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _showNoteDialog(context),
              tooltip: AppLocalizations.of(context).prepareNoteTitle,
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: item.note);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.prepareNoteTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l.prepareNoteHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          if (item.note != null)
            TextButton(
              onPressed: () {
                onNoteUpdate(null);
                Navigator.pop(ctx);
              },
              child: Text(l.commonRemove),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              onNoteUpdate(controller.text.isEmpty ? null : controller.text);
              Navigator.pop(ctx);
            },
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                l.prepareTipsTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _tipItem('🔄', l.prepareTip1Title, l.prepareTip1Body),
          _tipItem('💧', l.prepareTip2Title, l.prepareTip2Body),
          _tipItem('📱', l.prepareTip3Title, l.prepareTip3Body),
          _tipItem('🏠', l.prepareTip4Title, l.prepareTip4Body),
          _tipItem('📍', l.prepareTip5Title, l.prepareTip5Body),
        ],
      ),
    );
  }

  Widget _tipItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
