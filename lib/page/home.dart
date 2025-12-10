import 'package:flutter/material.dart';
import '../fragment/generate_text.dart';
import '../fragment/generate_image.dart';
import '../fragment/about.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    FragmentGenerateText(),
    FragmentGenerateImage(),
    FragmentAbout(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaW = MediaQuery.of(context).size.width;
    final isWideScreen = mediaW > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          'AI Cooking Helper',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
      ),
      // Body dengan page yang berubah sesuai tab
      body: Column(children: [Expanded(child: _pages[_selectedIndex])]),

      // Bottom Navigation Bar + Footer (Android-style)
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
              },
              backgroundColor: Colors.white,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey.shade600,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              iconSize: isWideScreen ? 28 : 24,
              selectedFontSize: isWideScreen ? 14 : 12,
              unselectedFontSize: isWideScreen ? 13 : 11,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields),
                  label: 'Resep dari Teks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: 'Resep dari Gambar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'Tentang',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
