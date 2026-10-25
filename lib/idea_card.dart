import 'package:flutter/material.dart';

import 'idea.dart';

class IdeaCard extends StatefulWidget {
  final Idea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  late int currentLikes;
  late bool isLiked;
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    currentLikes = widget.idea.likes;
    isLiked = widget.idea.liked;
    isSaved = widget.idea.saved;
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        currentLikes = (currentLikes - 1).clamp(0, 999999);
        isLiked = false;
      } else {
        currentLikes++;
        isLiked = true;
      }

      widget.idea.likes = currentLikes;
      widget.idea.liked = isLiked;
    });
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
      widget.idea.saved = isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? 'Idea saved!' : 'Idea removed from saved items',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void showDetails() {
    final idea = widget.idea;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(idea.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(idea.description),
              const SizedBox(height: 16),
              Chip(
                avatar: const Icon(Icons.category, size: 18),
                label: Text(idea.category),
              ),
              const SizedBox(height: 8),
              Text('Created by ${idea.author}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('$currentLikes likes'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 8),
                  Text(isSaved ? 'Saved' : 'Not saved'),
                ],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idea = widget.idea;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: showDetails,
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.indigo,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      idea.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.open_in_full, size: 18, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              idea.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: Chip(
                    label: Text(idea.category),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: isSaved ? 'Unsave idea' : 'Save idea',
                  onPressed: toggleSave,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.indigo : Colors.grey,
                  ),
                ),
                IconButton(
                  tooltip: isLiked ? 'Unlike idea' : 'Like idea',
                  onPressed: toggleLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Text('$currentLikes'),
              ],
            ),
            Text(
              'By ${idea.author}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: showDetails,
              child: const Text(
                'Tap to view full details',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
