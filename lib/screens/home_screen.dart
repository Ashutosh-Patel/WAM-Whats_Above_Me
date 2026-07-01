import 'package:flutter/material.dart';
import '../data/mock_cities.dart';
// To access the theme notifier

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late City _selectedCity;
  late AnimationController _floatController;
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _selectedCity = mockCities.first;

    // Floating animation for objects
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Cloud animation from right to left
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  void _onCityChanged(City? newCity) {
    if (newCity != null) {
      setState(() {
        _selectedCity = newCity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Earth'),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Space',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF020617)]
                    : [
                        Colors.lightBlue[200]!,
                        Colors.lightBlue[50]!,
                      ], // Sky blue for light theme
              ),
            ),
          ),

          // Animated Clouds Background
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              // Move from right (width) to left (-width)
              final offset1 =
                  screenWidth - (_cloudController.value * screenWidth * 2);
              final offset2 =
                  screenWidth -
                  (((_cloudController.value + 0.4) % 1.0) * screenWidth * 2);
              final offset3 =
                  screenWidth -
                  (((_cloudController.value + 0.8) % 1.0) * screenWidth * 2);

              return Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.1,
                    left: offset1,
                    child: _buildCloud(isDark),
                  ),
                  Positioned(
                    top: screenHeight * 0.3,
                    left: offset2,
                    child: _buildCloud(isDark, scale: 0.6),
                  ),
                  Positioned(
                    top: screenHeight * 0.2,
                    left: offset3,
                    child: _buildCloud(isDark, scale: 0.8),
                  ),
                ],
              );
            },
          ),

          // Earth Image at the bottom (half-sphere, moved upward)
          Positioned(
            left: (screenWidth - (screenHeight * 0.8)) / 2,
            bottom: -(screenHeight * 0.4), // Moved upward above bottom nav bar
            child: Container(
              width: screenHeight * 0.8,
              height: screenHeight * 0.8,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: Transform.scale(
                scale: 1.25, // Scale up to remove the black bezel
                child: Image.asset(
                  'assets/images/earth_illustration.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Child standing on the globe
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.3, // Positioned on top of the globe
            child: Center(
              child: SizedBox(
                width: screenHeight * 0.25,
                height: screenHeight * 0.25,
                child: Image.asset(
                  'assets/images/child.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Top SafeArea for App Bar / Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Left: Location with Dropdown
                  Flexible(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<City>(
                        value: _selectedCity,
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: false,
                        dropdownColor: theme.cardColor,
                        onChanged: _onCityChanged,
                        items: mockCities.map<DropdownMenuItem<City>>((
                          City city,
                        ) {
                          String displayText = '${city.name}, ${city.country}';
                          if (displayText.length > 15) {
                            displayText = '${displayText.substring(0, 15)}...';
                          }
                          return DropdownMenuItem<City>(
                            value: city,
                            child: Text(
                              displayText,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloud(bool isDark, {double scale = 1.0}) {
    return Transform.scale(
      scale: scale,
      child: Icon(
        Icons.cloud,
        size: 140,
        color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}
