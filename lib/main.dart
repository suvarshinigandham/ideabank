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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FC),
          foregroundColor: Colors.indigo,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

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
          'An intelligent planner that helps students organize '
          'their timetable, track tasks, and manage study time.',
      category: 'Education',
      author: 'IdeaBank Team',
      likes: 18,
    ),
    Idea(
      title: 'Campus Carpool',
      description:
          'A platform that connects students travelling in the '
          'same direction to share rides and reduce travel costs.',
      category: 'Transport',
      author: 'IdeaBank Team',
      likes: 24,
    ),
    Idea(
      title: 'Local Skill Exchange',
      description:
          'A community where people exchange skills, teach '
          'each other, and collaborate on useful projects.',
      category: 'Community',
      author: 'IdeaBank Team',
      likes: 31,
    ),
  ];

  void addIdea(Idea idea) {
    setState(() {
      ideas.insert(0, idea);
      selectedIndex = 0;
    });
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
      body: IndexedStack(index: selectedIndex, children: pages),
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
            Icon(Icons.lightbulb, color: Colors.indigo),
            SizedBox(width: 8),
            Text('IdeaBank', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3949AB), Color(0xFF7986CB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  'Ideas become innovation!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Share your ideas, discover new possibilities, '
                  'and collaborate with creative minds.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Discover Ideas',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              Text(
                '${ideas.length} ideas',
                style: const TextStyle(color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (ideas.isEmpty)
            const EmptyIdeasMessage(
              message: 'No ideas yet. Be the first to share one!',
            )
          else
            ...ideas.map((idea) => IdeaCard(key: ObjectKey(idea), idea: idea)),
        ],
      ),
    );
  }
}

// EXPLORE PAGE WITH SEARCH AND CATEGORY FILTERS

class ExplorePage extends StatefulWidget {
  final List<Idea> ideas;

  const ExplorePage({super.key, required this.ideas});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categorySet =
        widget.ideas
            .map((idea) => idea.category)
            .where((category) => category.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final categories = ['All', ...categorySet];
    final query = searchController.text.trim().toLowerCase();

    final filteredIdeas = widget.ideas.where((idea) {
      final matchesSearch =
          idea.title.toLowerCase().contains(query) ||
          idea.description.toLowerCase().contains(query) ||
          idea.category.toLowerCase().contains(query) ||
          idea.author.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' || idea.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Ideas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search ideas, topics, or authors...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter by category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
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
            const SizedBox(height: 16),
            Text(
              '${filteredIdeas.length} '
              'idea${filteredIdeas.length == 1 ? '' : 's'} found',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredIdeas.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 56, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No matching ideas found',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Try another category or search term.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredIdeas.length,
                      itemBuilder: (context, index) {
                        final idea = filteredIdeas[index];

                        return IdeaCard(key: ObjectKey(idea), idea: idea);
                      },
                    ),
            ),
          ],
        ),
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

  final List<String> categories = [
    'Education',
    'Technology',
    'Transport',
    'Community',
    'Health',
    'Environment',
    'Other',
  ];

  String selectedCategory = 'Education';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    authorController.dispose();
    super.dispose();
  }

  void submitIdea() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final newIdea = Idea(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      author: authorController.text.trim(),
      likes: 0,
    );

    widget.onSubmit(newIdea);

    titleController.clear();
    descriptionController.clear();
    authorController.clear();

    setState(() {
      selectedCategory = 'Education';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Your idea has been posted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share an Idea',
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Share it with the community and inspire others.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: titleController,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Idea title',
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
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain your idea...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe your idea';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
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
              const SizedBox(height: 18),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  hintText: 'Enter your name',
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: submitIdea,
                  icon: const Icon(Icons.send),
                  label: const Text('Publish Idea'),
                  style: FilledButton.styleFrom(
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
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border, size: 64, color: Colors.indigo),
                    SizedBox(height: 16),
                    Text(
                      'No saved ideas yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on any idea to save it here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: savedIdeas.length,
              itemBuilder: (context, index) {
                final idea = savedIdeas[index];

                return IdeaCard(key: ObjectKey(idea), idea: idea);
              },
            ),
    );
  }
}

// PROFILE PAGE

class ProfilePage extends StatelessWidget {
  final List<Idea> ideas;

  const ProfilePage({super.key, required this.ideas});

  @override
  Widget build(BuildContext context) {
    final totalLikes = ideas.fold<int>(0, (total, idea) => total + idea.likes);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFE8EAF6),
            child: Icon(Icons.person, size: 55, color: Colors.indigo),
          ),
          const SizedBox(height: 14),
          const Text(
            'IdeaBank Member',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Sharing ideas. Building possibilities.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _ProfileStat(
                  icon: Icons.lightbulb_outline,
                  label: 'Ideas',
                  value: '${ideas.length}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileStat(
                  icon: Icons.favorite_outline,
                  label: 'Total likes',
                  value: '$totalLikes',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Shared Ideas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (ideas.isEmpty)
            const EmptyIdeasMessage(
              message: 'Your shared ideas will appear here.',
            )
          else
            ...ideas.map(
              (idea) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8EAF6),
                  child: Icon(Icons.lightbulb_outline, color: Colors.indigo),
                ),
                title: Text(
                  idea.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(idea.category),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: Colors.indigo, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// EMPTY STATE WIDGET

class EmptyIdeasMessage extends StatelessWidget {
  final String message;

  const EmptyIdeasMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          const Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
