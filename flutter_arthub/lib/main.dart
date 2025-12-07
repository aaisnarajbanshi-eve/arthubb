import 'package:flutter/material.dart';

void main() {
  runApp(const ArtGalleryApp());
}

/// ROOT OF THE APPLICATION
class ArtGalleryApp extends StatelessWidget {
  const ArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const GalleryScreen(),
    );
  }
}

/* ============================================================
   ===============   DOMAIN LAYER – ART MODEL    ===============
   ============================================================ */

class ArtModel {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;
  final String description;

  ArtModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.description,
  });
}

/* ============================================================
   ===============   DATA LAYER – MOCK SOURCE   ===============
   ============================================================ */

class ArtDataSource {
  /// Returns static mock artwork data
  static List<ArtModel> fetchArtworks() {
    return [
      ArtModel(
        id: 1,
        title: "Starry Night",
        artist: "Vincent van Gogh",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg",
        description:
            "A famous oil on canvas painting by Vincent van Gogh showcasing a swirling night sky.",
      ),
      ArtModel(
        id: 2,
        title: "The Persistence of Memory",
        artist: "Salvador Dalí",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg",
        description:
            "An iconic surrealist painting featuring melting clocks in a mysterious landscape.",
      ),
      ArtModel(
        id: 3,
        title: "Girl with a Pearl Earring",
        artist: "Johannes Vermeer",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/d/d7/Meisje_met_de_parel.jpg",
        description:
            "Often called the 'Mona Lisa of the North', this artwork is known for its elegance.",
      ),
    ];
  }
}

/* ============================================================
   ===============   SERVICE – FAVORITES LOGIC   ==============
   ============================================================ */

class FavoritesService {
  static final List<int> _favoriteIds = [];

  static bool isFavorite(int id) => _favoriteIds.contains(id);

  static void toggleFavorite(int id) {
    if (isFavorite(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
  }

  static List<int> get favorites => _favoriteIds;
}

/* ============================================================
   ===============   UI – REUSABLE ART CARD     ===============
   ============================================================ */

class ArtCard extends StatelessWidget {
  final ArtModel art;
  final VoidCallback onTap;

  const ArtCard({super.key, required this.art, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                art.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Title + Artist
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    art.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    art.artist,
                    style: const TextStyle(color: Colors.black54),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   ===============   UI – GALLERY SCREEN       ===============
   ============================================================ */

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late List<ArtModel> artworks;
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    artworks = ArtDataSource.fetchArtworks();
  }

  @override
  Widget build(BuildContext context) {
    // Filter results based on search text
    final filteredArtworks = artworks.where((art) {
      final query = searchTerm.toLowerCase();
      return art.title.toLowerCase().contains(query) ||
          art.artist.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Art Gallery")),

      body: Column(
        children: [
          // ---------------- SEARCH BAR ----------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search artworks...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),

          // ---------------- ART LIST ----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredArtworks.length,
              itemBuilder: (context, index) {
                final art = filteredArtworks[index];
                return ArtCard(
                  art: art,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArtDetailScreen(art: art),
                      ),
                    ).then((_) => setState(() {})); // refresh favorites
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   ===============   UI – ART DETAIL SCREEN    ===============
   ============================================================ */

class ArtDetailScreen extends StatefulWidget {
  final ArtModel art;

  const ArtDetailScreen({super.key, required this.art});

  @override
  State<ArtDetailScreen> createState() => _ArtDetailScreenState();
}

class _ArtDetailScreenState extends State<ArtDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoritesService.isFavorite(widget.art.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.art.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () {
              FavoritesService.toggleFavorite(widget.art.id);
              setState(() {});
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.art.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.art.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "By ${widget.art.artist}",
                    style: const TextStyle(
                        fontSize: 18, color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.art.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
