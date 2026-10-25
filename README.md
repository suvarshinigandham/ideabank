![IdeaBank Project Overview](screenshots/ideabank_overview.png)

# 💡 IdeaBank — Share Ideas, Get Feedback, Build Together

IdeaBank is a Flutter-based idea-sharing application that helps users share creative ideas, discover innovative concepts, and connect through likes, bookmarks, and comments.

Explore ideas, filter by category, sort by popularity, publish new ideas, and manage your profile through a clean, interactive Material 3 interface.

**Built with:** Flutter · Dart · Material 3

---

## 🎯 About the Project

IdeaBank provides a common platform for sharing ideas, receiving feedback, and discovering concepts from a community. It aims to make idea discovery and collaboration simple and accessible.

## ✨ Features

- 🏠 **Home:** Discover ideas from the community.
- 🔍 **Explore:** Search ideas by title, description, or author.
- 🏷️ **Category Filters:** Filter ideas by category.
- 🔃 **Sorting:** Sort by Newest, Oldest, or Most Liked.
- ➕ **Post Idea:** Publish ideas with a title, description, category, and author name.
- ❤️ **Likes:** Like and unlike ideas.
- 💬 **Comments:** Share feedback and view comments.
- 🔖 **Saved Ideas:** Bookmark ideas for later.
- 👤 **Profile:** Edit your display name and bio.
- 📊 **Activity Statistics:** View idea, like, and saved-idea counts.
- 🎨 **Modern UI:** Purple theme with Material 3 components.

## 📱 Application Screens

IdeaBank includes five main sections:

1. Home
2. Explore
3. Post Idea
4. Saved Ideas
5. Profile

Additional interactions include idea details, comments, profile editing, and empty states.

## 🛠️ Technology Stack

- **Flutter** — UI framework
- **Dart** — Programming language
- **Material 3** — Interface design
- **Visual Studio Code** — Development environment
- **Git and GitHub** — Version control and source hosting

## 📂 Project Structure

```text
ideabank/
├── lib/
│   ├── main.dart
│   ├── idea.dart
│   └── idea_card.dart
├── screenshots/
│   └── ideabank_overview.png
├── pubspec.yaml
└── README.md
```

- `main.dart` — Main application and screens.
- `idea.dart` — Idea data model.
- `idea_card.dart` — Idea cards and interactions.
- `screenshots/` — Project overview and screenshots.
- `pubspec.yaml` — Flutter dependencies and configuration.

## ⚙️ Getting Started

### Prerequisites

Install Flutter and set up a supported browser, emulator, or device.

Check your installation:

```bash
flutter --version
flutter doctor
```

### 1. Clone the repository

```bash
git clone https://github.com/suvarshinigandham/ideabank.git
cd ideabank
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
flutter run -d chrome
```

### 4. Format and analyze

```bash
dart format lib/main.dart lib/idea.dart lib/idea_card.dart
flutter analyze
```

## 🧭 How to Use

1. Open Home to browse ideas.
2. Go to Explore to search, filter, and sort ideas.
3. Open an idea to read details and add comments.
4. Like or bookmark ideas.
5. Use Post Idea to submit a new idea.
6. Open Saved to view bookmarked ideas.
7. Visit Profile to edit your name and bio and view activity statistics.

## 🔃 Sorting Options

- **Newest:** Shows ideas at the beginning of the current list first.
- **Oldest:** Shows ideas at the end of the current list first.
- **Most Liked:** Sorts ideas by descending like count.

Newest and Oldest currently use list order because posting timestamps are not stored.

## ⚠️ Current Limitations

IdeaBank is currently a front-end prototype.

- Ideas and interactions are stored in memory.
- Likes, comments, bookmarks, and profile edits reset when the app restarts.
- Authentication and backend database integration are not implemented.
- Comments are not synchronized between users or devices.

## 🔮 Future Enhancements

- User registration and authentication.
- Firebase or another backend database.
- Persistent storage and cross-device synchronization.
- Profile pictures and richer user profiles.
- Notifications for likes and comments.
- Following users and finding collaborators.
- Automated testing and accessibility improvements.

## 📚 Learning Outcomes

This project provides practical experience with Flutter, Dart, stateful widgets, reusable components, form validation, navigation, searching, filtering, sorting, interactive UI elements, and Git/GitHub workflows.

## 👩‍💻 Author

**Suvarshini Gandham**

- GitHub: [suvarshinigandham](https://github.com/suvarshinigandham)
- LinkedIn: [Suvarshini Gandham](https://www.linkedin.com/in/suvarshini-gandham/)

---

**IdeaBank — Build. Share. Make an impact.**
