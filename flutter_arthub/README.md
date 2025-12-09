# 🎨 Art Gallery App

A simple Flutter application showcasing a mock art gallery where users can browse famous artworks, view details, and mark their favorite pieces.

---

## ✨ Features

* Display a list of artworks
* Search artworks by title or artist
* View detailed information about each artwork
* Mark/unmark artworks as favorites
* Clean UI built with Material 3

---

## 🏗 App Architecture

The project follows a simple **layered structure**:

| Layer       | Purpose                               |
| ----------- | ------------------------------------- |
| **Domain**  | Art model representing data structure |
| **Data**    | Mock static data source for artworks  |
| **Service** | Manages favorite logic (in-memory)    |
| **UI**      | Screens and reusable widgets          |

---

## 📂 Project Structure

```
lib/
├── main.dart
├── models/
│   └── art_model.dart
├── data/
│   └── art_data_source.dart
├── services/
│   └── favorites_service.dart
├── widgets/
│   └── art_card.dart
└── screens/
    ├── gallery_screen.dart
    └── art_detail_screen.dart
```

> (Note: The provided example keeps all in `main.dart`, but this is the recommended structure.)

---

## 🚀 How to Run

Make sure you have Flutter installed.

```bash
git clone <your-repo-link>
cd art_gallery_app
flutter pub get
flutter run
```

---

## 🧪 Future Improvements

* Add real API integration
* Local storage for favorites
* Categories / Filters
* Animations for transitions

---

## 📸 Preview

*(Add screenshots here if available)*

---

## 🖼 Artwork Credits

All artwork images sourced from public Wikipedia image links.

---

## 📄 License

This project is free to use and modify for learning purposes.
