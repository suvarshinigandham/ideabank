import 'package:flutter/material.dart';

import 'idea.dart';

class IdeaCard extends StatefulWidget {
  final Idea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      if (widget.idea.liked) {
        widget.idea.likes = (widget.idea.likes - 1).clamp(0, 999999);
        widget.idea.liked = false;
      } else {
        widget.idea.likes++;
        widget.idea.liked = true;
      }
    });
  }

  void toggleSave() {
    setState(() {
      widget.idea.saved = !widget.idea.saved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.idea.saved
              ? 'Idea added to Saved!'
              : 'Idea removed from Saved.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void addComment() {
    final text = commentController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      widget.idea.comments.add(text);
      commentController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  void showIdeaDetails() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(widget.idea.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.category_outlined, size: 18),
                      label: Text(widget.idea.category),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.idea.description),
                    const SizedBox(height: 12),
                    Text(
                      'Posted by ${widget.idea.author}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const Divider(height: 28),
                    Text(
                      'Feedback (${widget.idea.comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.idea.comments.isEmpty)
                      const Text('No comments yet. Be the first to comment.')
                    else
                      ...widget.idea.comments.map(
                        (comment) => Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person_outline),
                            ),
                            title: Text(comment),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: commentController,
                      maxLength: 200,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Write your feedback...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final text = commentController.text.trim();

                          if (text.isEmpty) return;

                          setState(() {
                            widget.idea.comments.add(text);
                            commentController.clear();
                          });

                          setDialogState(() {});
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Add Comment'),
                      ),
                    ),
                  ],
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.idea.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'by ${widget.idea.author}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: widget.idea.saved ? 'Unsave idea' : 'Save idea',
                  onPressed: toggleSave,
                  icon: Icon(
                    widget.idea.saved ? Icons.bookmark : Icons.bookmark_border,
                    color: widget.idea.saved
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.idea.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(widget.idea.category),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                IconButton(
                  onPressed: toggleLike,
                  tooltip: widget.idea.liked ? 'Unlike' : 'Like',
                  icon: Icon(
                    widget.idea.liked ? Icons.favorite : Icons.favorite_border,
                    color: widget.idea.liked ? Colors.red : null,
                  ),
                ),
                Text('${widget.idea.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: showIdeaDetails,
                  tooltip: 'View comments and details',
                  icon: const Icon(Icons.mode_comment_outlined),
                ),
                Text('${widget.idea.comments.length} comments'),
                const Spacer(),
                TextButton(
                  onPressed: showIdeaDetails,
                  child: const Text('View idea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
