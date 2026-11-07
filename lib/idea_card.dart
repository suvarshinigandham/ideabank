import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'idea.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  final List<Idea> allIdeas;
  final VoidCallback onChanged;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.allIdeas,
    required this.onChanged,
  });

  void toggleLike() {
    if (idea.liked) {
      idea.likes--;
      idea.liked = false;
    } else {
      idea.likes++;
      idea.liked = true;
    }
    onChanged();
  }

  void toggleSave() {
    idea.saved = !idea.saved;
    onChanged();
  }

  void shareIdea(BuildContext context) {
    final shareText =
        '${idea.title}\n\n${idea.description}\n\nShared from IdeaBank';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Idea copied! You can now share it.')),
    );
  }

  String formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    }
    if (difference.inDays == 1) return 'yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> deleteIdea(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Idea?'),
        content: const Text(
          'Are you sure you want to delete this idea? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      allIdeas.remove(idea);
      onChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Idea deleted successfully!')),
      );
    }
  }

  void editIdea(BuildContext context) {
    final titleController = TextEditingController(text: idea.title);
    final descriptionController = TextEditingController(text: idea.description);
    final authorController = TextEditingController(text: idea.author);

    final categories = [
      'Technology',
      'Education',
      'Transportation',
      'Health',
      'Environment',
      'Business',
      'Other',
    ];

    String selectedCategory = categories.contains(idea.category)
        ? idea.category
        : 'Other';

    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Your Idea'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      maxLength: 80,
                      decoration: const InputDecoration(
                        labelText: 'Idea Title',
                        prefixIcon: Icon(Icons.lightbulb_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 5) {
                          return 'Enter at least 5 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      maxLength: 500,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 20) {
                          return 'Enter at least 20 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: authorController,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: 'Author Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                idea.title = titleController.text.trim();
                idea.description = descriptionController.text.trim();
                idea.category = selectedCategory;
                idea.author = authorController.text.trim();

                onChanged();
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Idea updated successfully!')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    ).then((_) {
      titleController.dispose();
      descriptionController.dispose();
      authorController.dispose();
    });
  }

  // ENHANCED IDEA DETAILS PAGE

  void showIdeaDetails(BuildContext context) {
    final commentController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            title: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 10),
                const Expanded(child: Text('Idea Details')),
                IconButton(
                  tooltip: 'Share idea',
                  onPressed: () => shareIdea(context),
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      idea.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.category_outlined, size: 18),
                          label: Text(idea.category),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                          ),
                          label: Text(formatDate(idea.createdAt)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Posted by',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    idea.author,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'About this Idea',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(idea.description, style: const TextStyle(height: 1.6)),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _detailStat(
                            Icons.favorite,
                            '${idea.likes}',
                            'Likes',
                          ),
                        ),
                        Expanded(
                          child: _detailStat(
                            Icons.comment,
                            '${idea.comments.length}',
                            'Comments',
                          ),
                        ),
                        Expanded(
                          child: _detailStat(
                            Icons.bookmark,
                            idea.saved ? 'Saved' : 'Not saved',
                            'Status',
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Community Comments',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (idea.comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 35),
                              SizedBox(height: 8),
                              Text('No comments yet.'),
                              Text('Be the first to share feedback!'),
                            ],
                          ),
                        ),
                      )
                    else
                      ...idea.comments.map(
                        (comment) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: Text(comment),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: commentController,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: 'Write your feedback...',
                        prefixIcon: Icon(Icons.comment_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final comment = commentController.text.trim();

                          if (comment.isEmpty) return;

                          idea.comments.add(comment);
                          commentController.clear();

                          onChanged();
                          setDialogState(() {});
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Post Comment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      commentController.dispose();
    });
  }

  Widget _detailStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        idea.author,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(idea.category, style: theme.textTheme.bodySmall),
                      Text(
                        'Posted ${formatDate(idea.createdAt)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit idea',
                  onPressed: () => editIdea(context),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete idea',
                  onPressed: () => deleteIdea(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                IconButton(
                  tooltip: idea.saved ? 'Unsave idea' : 'Save idea',
                  onPressed: toggleSave,
                  icon: Icon(
                    idea.saved ? Icons.bookmark : Icons.bookmark_border,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              idea.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              idea.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => showIdeaDetails(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Full Details'),
            ),
            const Divider(),
            Row(
              children: [
                IconButton(
                  onPressed: toggleLike,
                  icon: Icon(
                    idea.liked ? Icons.favorite : Icons.favorite_border,
                    color: idea.liked ? Colors.red : null,
                  ),
                ),
                Text('${idea.likes} Likes'),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => showIdeaDetails(context),
                  icon: const Icon(Icons.comment_outlined),
                ),
                Text('${idea.comments.length} Comments'),
                IconButton(
                  tooltip: 'Share idea',
                  onPressed: () => shareIdea(context),
                  icon: const Icon(Icons.share_outlined),
                ),
                const Spacer(),
                if (idea.saved)
                  const Icon(Icons.bookmark, color: Color(0xFF6750A4)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
