
import 'package:flutter/material.dart';
import 'idea.dart';
import 'idea_card.dart';

void main() {
  runApp(const IdeaBankApp());
}

class IdeaBankApp extends StatelessWidget {
  const IdeaBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdeaBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F7FC),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// MAIN SCREEN AND NAVIGATION

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Idea> ideas = [
    Idea(
      title: 'Smart Study Planner',
      description:
          'An intelligent planner that creates personalized study '
          'schedules based on subjects, deadlines, and available time.',
      category: 'Education',
      author: 'Suvarshini',
      likes: 18,
    ),
    Idea(
      title: 'Campus Carpool',
      description:
          'Connect students travelling in the same direction to '
          'share rides and reduce travel costs.',
      category: 'Transportation',
      author: 'Rahul',
      likes: 24,
    ),
    Idea(
      title: 'Local Skill Exchange',
      description:
          'A platform where students exchange skills such as coding, '
          'design, communication, and photography.',
      category: 'Technology',
      author: 'Priya',
      likes: 31,
    ),
  ];

  void addIdea(Idea idea) {
    setState(() {
      ideas.insert(0, idea);
      selectedIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your idea was posted successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(ideas: ideas),
      ExplorePage(ideas: ideas),
      PostPage(onSubmit: addIdea),
      SavedIdeasPage(ideas: ideas),
      ProfilePage(ideas: ideas),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Post Idea',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// HOME PAGE

class HomePage extends StatelessWidget {
  final List<Idea> ideas;

  const HomePage({super.key, required this.ideas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.lightbulb,
              color: Color(0xFF6750A4),
            ),
            SizedBox(width: 8),
            Text(
              'IdeaBank',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'About IdeaBank',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'IdeaBank',
                applicationVersion: '1.0.0',
                children: const [
                  Text(
                    'Discover ideas, share feedback, and collaborate '
                    'with creative people.',
                  ),
                ],
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6750A4),
                  Color(0xFF9582D4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 42,
                  color: Colors.white,
                ),
                SizedBox(height: 14),
                Text(
                  'Every great idea starts somewhere.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Share your ideas, get feedback, and find people '
                  'who want to build something amazing.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Discover Ideas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore what the community is thinking about.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          if (ideas.isEmpty)
            const EmptyIdeasMessage(
              message: 'No ideas yet. Be the first to share one!',
            )
          else
            ...ideas.map(
              (idea) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IdeaCard(idea: idea),
              ),
            ),
        ],
      ),
    );
  }
}

// EXPLORE PAGE WITH SEARCH, CATEGORY FILTERS AND SORTING

class ExplorePage extends StatefulWidget {
  final List<Idea> ideas;

  const ExplorePage({super.key, required this.ideas});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String searchText = '';
  String selectedCategory = 'All';
  String selectedSort = 'Newest';

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      ...widget.ideas.map((idea) => idea.category).toSet(),
    ];

    final filteredIdeas = widget.ideas.where((idea) {
      final query = searchText.toLowerCase();

      final matchesSearch =
          idea.title.toLowerCase().contains(query) ||
          idea.description.toLowerCase().contains(query) ||
          idea.author.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
          idea.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    // New ideas are inserted at index 0.
    if (selectedSort == 'Most Liked') {
      filteredIdeas.sort(
        (a, b) => b.likes.compareTo(a.likes),
      );
    } else if (selectedSort == 'Oldest') {
      filteredIdeas.sort(
        (a, b) => widget.ideas.indexOf(b).compareTo(
              widget.ideas.indexOf(a),
            ),
      );
    } else {
      filteredIdeas.sort(
        (a, b) => widget.ideas.indexOf(a).compareTo(
              widget.ideas.indexOf(b),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Ideas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ideas, descriptions, or authors',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];

                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.sort, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Sort by:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedSort,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Newest',
                        child: Text('Newest'),
                      ),
                      DropdownMenuItem(
                        value: 'Oldest',
                        child: Text('Oldest'),
                      ),
                      DropdownMenuItem(
                        value: 'Most Liked',
                        child: Text('Most Liked'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredIdeas.isEmpty
                ? const EmptyIdeasMessage(
                    message:
                        'No matching ideas found. Try another search.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredIdeas.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: IdeaCard(idea: filteredIdeas[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// POST IDEA PAGE

class PostPage extends StatefulWidget {
  final ValueChanged<Idea> onSubmit;

  const PostPage({super.key, required this.onSubmit});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();

  String selectedCategory = 'Technology';

  final List<String> categories = [
    'Technology',
    'Education',
    'Transportation',
    'Health',
    'Environment',
    'Business',
    'Other',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    authorController.dispose();
    super.dispose();
  }

  void submitIdea() {
    if (!formKey.currentState!.validate()) return;

    final idea = Idea(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      author: authorController.text.trim(),
    );

    widget.onSubmit(idea);

    titleController.clear();
    descriptionController.clear();
    authorController.clear();

    setState(() {
      selectedCategory = 'Technology';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Your Idea',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Have a great idea?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Describe it and share it with the IdeaBank community.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: titleController,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Idea Title',
                  hintText: 'Give your idea a name',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an idea title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLength: 500,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain your idea...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe your idea';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authorController,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: submitIdea,
                  icon: const Icon(Icons.send),
                  label: const Text('Publish Idea'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SAVED IDEAS PAGE

class SavedIdeasPage extends StatelessWidget {
  final List<Idea> ideas;

  const SavedIdeasPage({super.key, required this.ideas});

  @override
  Widget build(BuildContext context) {
    final savedIdeas = ideas.where((idea) => idea.saved).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Ideas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: savedIdeas.isEmpty
          ? const EmptyIdeasMessage(
              message:
                  'No saved ideas yet. Bookmark an idea to find it here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedIdeas.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IdeaCard(idea: savedIdeas[index]),
                );
              },
            ),
    );
  }
}

// PROFILE PAGE

class ProfilePage extends StatefulWidget {
  final List<Idea> ideas;

  const ProfilePage({super.key, required this.ideas});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = 'IdeaBank User';
  String bio = 'Sharing ideas, learning, and building together.';

  void editProfile() {
    final nameController = TextEditingController(text: displayName);
    final bioController = TextEditingController(text: bio);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  maxLength: 40,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioController,
                  maxLength: 120,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.edit_note),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (nameController.text.trim().isNotEmpty) {
                    displayName = nameController.text.trim();
                  }
                  bio = bioController.text.trim();
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      bioController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalIdeas = widget.ideas.length;
    final totalLikes = widget.ideas.fold<int>(
      0,
      (sum, idea) => sum + idea.likes,
    );
    final savedIdeas = widget.ideas.where((idea) => idea.saved).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 52,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 58,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.lightbulb_outline,
                    label: 'Ideas',
                    value: totalIdeas.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.favorite_outline,
                    label: 'Likes',
                    value: totalLikes.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.bookmark_outline,
                    label: 'Saved',
                    value: savedIdeas.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: const Text('IdeaBank Community'),
                subtitle: const Text(
                  'Share ideas and collaborate with others.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('IdeaBank Community'),
                      content: const Text(
                        'Explore ideas, share feedback, and discover '
                        'people to collaborate with.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 6,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 27,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// EMPTY STATE WIDGET

class EmptyIdeasMessage extends StatelessWidget {
  final String message;

  const EmptyIdeasMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
