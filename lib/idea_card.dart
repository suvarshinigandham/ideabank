import 'package:flutter/material.dart';

import 'idea.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  final VoidCallback onChanged;

  const IdeaCard({super.key, required this.idea, required this.onChanged});

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
                    ],
                  ),
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

                const SizedBox(width: 18),

                IconButton(
                  onPressed: () => showIdeaDetails(context),
                  icon: const Icon(Icons.comment_outlined),
                ),

                Text('${idea.comments.length} Comments'),

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
