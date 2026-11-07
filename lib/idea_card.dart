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

  // LIKE AND UNLIKE IDEA

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

  // SAVE AND UNSAVE IDEA

  void toggleSave() {
    idea.saved = !idea.saved;
    onChanged();
  }

  // SHARE IDEA

  void shareIdea(BuildContext context) {
    final shareText =
        '${idea.title}\n\n'
        '${idea.description}\n\n'
        'Shared from IdeaBank';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Idea copied! You can now share it.')),
    );
  }

  // FORMAT DATE

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

  // DELETE IDEA

  Future<void> deleteIdea(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Idea?'),
          content: const Text(
            'Are you sure you want to delete this idea? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
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

  // EDIT IDEA

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
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
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
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
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
                      const SnackBar(
                        content: Text('Idea updated successfully!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      titleController.dispose();
      descriptionController.dispose();
      authorController.dispose();
    });
  }

  // VIEW IDEA DETAILS AND COMMENTS

  void showIdeaDetails(BuildContext context) {
    final commentController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(idea.title),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(idea.category)),
                      const SizedBox(height: 12),
                      Text(idea.description),
                      const SizedBox(height: 16),
                      Text(
                        'Posted by ${idea.author}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Posted ${formatDate(idea.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Divider(height: 28),
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (idea.comments.isEmpty)
                        const Text('No comments yet.')
                      else
                        ...idea.comments.map(
                          (comment) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(comment),
                          ),
                        ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: commentController,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                          prefixIcon: Icon(Icons.comment_outlined),
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
                          label: const Text('Add Comment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      commentController.dispose();
    });
  }

  // BUILD IDEA CARD

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
            TextButton(
              onPressed: () => showIdeaDetails(context),
              child: const Text('View Details'),
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
                const SizedBox(width: 12),
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
