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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          'An intelligent study planner that helps students '
          'organize subjects, manage time, and track study goals.',
      category: 'Education',
      author: 'Suvarshini',
      likes: 18,
    ),
    Idea(
      title: 'Campus Carpool',
      description:
          'A platform that connects students travelling in '
          'the same direction to share rides and reduce costs.',
      category: 'Transportation',
      author: 'Rahul',
      likes: 24,
    ),
    Idea(
      title: 'Local Skill Exchange',
      description:
          'A community where students exchange skills such as '
          'coding, design, communication, and project building.',
      category: 'Community',
      author: 'Ananya',
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
            label: 'Post',
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

class HomePage extends StatelessWidget {
  final List<Idea> ideas;

  const HomePage({super.key, required this.ideas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IdeaBank',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Explore ideas',
            onPressed: () {
              // The Explore tab is available in bottom navigation.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Explore ideas using the Explore tab.'),
                ),
              );
            },
            icon: const Icon(Icons.lightbulb_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Color(0xFF7986CB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb, color: Colors.white, size: 38),
                SizedBox(height: 12),
                Text(
                  'Ideas can change the world!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Share your ideas, discover inspiration, '
                  'and build something amazing together.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Trending Ideas',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Text('${ideas.length} ideas'),
            ],
          ),
          const SizedBox(height: 8),
          if (ideas.isEmpty)
            const EmptyIdeasMessage(
              message: 'No ideas yet. Be the first to share one!',
            )
          else
            ...ideas.map((idea) => IdeaCard(key: ValueKey(idea), idea: idea)),
        ],
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  final List<Idea> ideas;

  const ExplorePage({super.key, required this.ideas});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();

    final filteredIdeas = widget.ideas.where((idea) {
      return idea.title.toLowerCase().contains(query) ||
          idea.description.toLowerCase().contains(query) ||
          idea.category.toLowerCase().contains(query) ||
          idea.author.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Ideas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search ideas, categories, or authors',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          Expanded(
            child: filteredIdeas.isEmpty
                ? const EmptyIdeasMessage(message: 'No matching ideas found.')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredIdeas.length,
                    itemBuilder: (context, index) {
                      final idea = filteredIdeas[index];
                      return IdeaCard(key: ValueKey(idea), idea: idea);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

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

  String category = 'Education';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    authorController.dispose();
    super.dispose();
  }

  void publishIdea() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final idea = Idea(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: category,
      author: authorController.text.trim(),
    );

    widget.onSubmit(idea);

    titleController.clear();
    descriptionController.clear();
    authorController.clear();

    setState(() {
      category = 'Education';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Idea published successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an Idea')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Icon(Icons.lightbulb, color: Colors.indigo, size: 60),
                const SizedBox(height: 12),
                const Text(
                  'Share Your Next Big Idea!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inspire others by sharing your creativity.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: titleController,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Idea title',
                    hintText: 'Enter your idea title',
                    prefixIcon: Icon(Icons.title),
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
                  maxLines: 4,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your idea...',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items:
                      const [
                        'Education',
                        'Technology',
                        'Transportation',
                        'Community',
                        'Health',
                        'Environment',
                      ].map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => category = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    labelText: 'Your name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: publishIdea,
                  icon: const Icon(Icons.send),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Publish Idea'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final List<Idea> ideas;

  const ProfilePage({super.key, required this.ideas});

  @override
  Widget build(BuildContext context) {
    final totalLikes = ideas.fold<int>(0, (sum, idea) => sum + idea.likes);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.indigo,
            child: Icon(Icons.person, color: Colors.white, size: 55),
          ),
          const SizedBox(height: 16),
          const Text(
            'IdeaBank Member',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Think. Share. Collaborate.', textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _ProfileStat(label: 'Ideas', value: '${ideas.length}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileStat(label: 'Total Likes', value: '$totalLikes'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'About IdeaBank',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'IdeaBank is a space to share creative ideas, '
            'discover solutions, and connect with people '
            'who want to make a difference.',
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Share creative ideas'),
          ),
          const ListTile(
            leading: Icon(Icons.groups_outlined),
            title: Text('Connect with innovators'),
          ),
          const ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text('Support community ideas'),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class EmptyIdeasMessage extends StatelessWidget {
  final String message;

  const EmptyIdeasMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
