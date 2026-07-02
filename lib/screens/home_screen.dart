import 'dart:math' as math;
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
  late final List<City> _mockHistory;
  late final List<City> _mockSaved;

  @override
  void initState() {
    super.initState();
    _selectedCity = mockCities.first;
    _mockHistory = mockCities.skip(1).take(5).toList();
    _mockSaved = [mockCities[0], mockCities[2], mockCities[4]];

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

  bool _isSearchExpanded = false;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          width: screenWidth, // Cover whole screen
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Profile Panel
                Container(
                  padding: const EdgeInsets.all(24.0),
                  color: theme.cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ashutosh',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        'Indore',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('Saved Cities'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('History'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Setting'),
                        onTap: () {},
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Help'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  padding: const EdgeInsets.all(16.0),
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Made by '),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.favorite,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(text: ' - Ashutosh Patel'),
                        ],
                      ),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
            // Background Gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _selectedIndex == 2
                      ? [
                          const Color(0xFF0A001F),
                          const Color(0xFF000000),
                        ] // Space shade
                      : (isDark
                          ? [const Color(0xFF0F172A), const Color(0xFF020617)]
                          : (_selectedIndex == 0
                              ? [Colors.yellow[100]!, Colors.yellow[50]!]
                              : [Colors.lightBlue[200]!, Colors.lightBlue[50]!])),
                ),
              ),
            ),
            // Glittering Stars Background
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _selectedIndex == 2 ? 1.0 : 0.0,
              child: const StarsBackground(),
            ),

            // Animated Clouds Background
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _selectedIndex == 1 ? 1.0 : 0.0,
              child: AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  // Move from right (width) to left (-width)
                  final offset1 =
                      screenWidth - (_cloudController.value * screenWidth * 2);
                  final offset2 =
                      screenWidth -
                      (((_cloudController.value + 0.3) % 1.0) *
                          screenWidth *
                          2);
                  final offset3 =
                      screenWidth -
                      (((_cloudController.value + 0.6) % 1.0) *
                          screenWidth *
                          2);
                  final offset4 =
                      screenWidth -
                      (((_cloudController.value + 0.15) % 1.0) *
                          screenWidth *
                          2);
                  final offset5 =
                      screenWidth -
                      (((_cloudController.value + 0.45) % 1.0) *
                          screenWidth *
                          2);
                  final offset6 =
                      screenWidth -
                      (((_cloudController.value + 0.85) % 1.0) *
                          screenWidth *
                          2);

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
                      Positioned(
                        top: screenHeight * 0.15,
                        left: offset4,
                        child: _buildCloud(isDark, scale: 0.7),
                      ),
                      Positioned(
                        top: screenHeight * 0.35,
                        left: offset5,
                        child: _buildCloud(isDark, scale: 0.5),
                      ),
                      Positioned(
                        top: screenHeight * 0.25,
                        left: offset6,
                        child: _buildCloud(isDark, scale: 0.9),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Earth and Child Group
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: (screenWidth - (screenHeight * 0.8)) / 2,
              bottom: -(screenHeight * 0.60),
              width: screenHeight * 0.8,
              height: screenHeight * 0.8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: (_selectedIndex == 1 || _selectedIndex == 2)
                    ? 1.0
                    : 0.0,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Earth Image
                    Container(
                      width: screenHeight * 0.8,
                      height: screenHeight * 0.8,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/earth_day_transparent.png',
                            fit: BoxFit.cover,
                          ),
                          // Night effect image
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _selectedIndex == 2 ? 1.0 : 0.0,
                            child: Image.asset(
                              'assets/images/earth_night_transparent.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Child standing on the globe
                    Positioned(
                      bottom:
                          screenHeight *
                          0.74, // Positioned relative to the bottom of the globe container
                      child: SizedBox(
                        width: screenHeight * 0.15,
                        height: screenHeight * 0.15,
                        child: Image.asset(
                          'assets/images/child.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Left: Location with Dropdown
                        Flexible(
                          child: PopupMenuButton<City>(
                            initialValue: _selectedCity,
                            onSelected: (City? newCity) {
                              if (newCity != null) {
                                _onCityChanged(newCity);
                              }
                            },
                            color: theme.cardColor,
                            position: PopupMenuPosition.under,
                            itemBuilder: (BuildContext context) {
                              return mockCities.map((City city) {
                                return PopupMenuItem<City>(
                                  value: city,
                                  child: Text(
                                    '${city.name}, ${city.country}',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                );
                              }).toList();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_selectedCity.name}, ${_selectedCity.country}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: _selectedIndex == 2
                                              ? Colors.white
                                              : null,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: _selectedIndex == 2
                                      ? Colors.white
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _isSearchExpanded
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Latitude',
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                Icons.arrow_drop_up,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isSearchExpanded = false;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                  horizontal: 16,
                                                ),
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: theme.unselectedWidgetColor
                                              .withValues(alpha: 0.2),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Longitude',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 14,
                                                  horizontal: 16,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search for a City',
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onPressed: () {
                                          setState(() {
                                            _isSearchExpanded = true;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 16,
                                          ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search),
                        ),
                      ],
                    ),
                    
                    // History and Saved Sections
                    IgnorePointer(
                      ignoring: _selectedIndex != 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _selectedIndex == 0 ? 1.0 : 0.0,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: _selectedIndex == 0 ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24.0),
                              _buildLocationList('History', _mockHistory, theme, isDark),
                              const SizedBox(height: 24.0),
                              _buildLocationList('Saved', _mockSaved, theme, isDark),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationList(String title, List<City> locations, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, index) {
              final city = locations[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            title == 'History' ? Icons.history : Icons.bookmark,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              city.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        city.country,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        '${city.latitude.toStringAsFixed(2)}, ${city.longitude.toStringAsFixed(2)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: theme.textTheme.labelSmall?.color?.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCloud(bool isDark, {double scale = 1.0}) {
    return Transform(
      transform: Matrix4.diagonal3Values(scale * 1.8, scale * 0.65, 1.0),
      alignment: Alignment.center,
      child: Icon(
        Icons.cloud,
        size: 140,
        color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.6),
      ),
    );
  }
}

class Star {
  double x;
  double y;
  double size;
  double opacity;
  double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

class StarsBackground extends StatefulWidget {
  const StarsBackground({super.key});

  @override
  State<StarsBackground> createState() => _StarsBackgroundState();
}

class _StarsBackgroundState extends State<StarsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stars.isEmpty) {
      final size = MediaQuery.of(context).size;
      final random = math.Random();
      for (int i = 0; i < 150; i++) {
        _stars.add(
          Star(
            x: random.nextDouble() * size.width,
            y: random.nextDouble() * size.height,
            size: random.nextDouble() * 2.0 + 0.5,
            opacity: random.nextDouble(),
            twinkleSpeed: random.nextDouble() * 1.5 + 0.5,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarsPainter(
            stars: _stars,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var star in stars) {
      // Calculate twinkling opacity
      double currentOpacity =
          star.opacity +
          (math.sin(animationValue * math.pi * 2 * star.twinkleSpeed) * 0.4);
      currentOpacity = currentOpacity.clamp(0.1, 1.0);
      paint.color = Colors.white.withValues(alpha: currentOpacity);
      canvas.drawCircle(Offset(star.x, star.y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) => true;
}
